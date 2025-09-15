Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79EFCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52C668E000E; Mon, 15 Sep 2025 12:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503C58E0001; Mon, 15 Sep 2025 12:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4198B8E000E; Mon, 15 Sep 2025 12:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF088E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:18:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D219713B237
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:18:52 +0000 (UTC)
X-FDA: 83891993304.29.3F238DD
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3E3D1C0004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:18:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=j7Kfrjvm;
	spf=pass (imf10.hostedemail.com: domain of "prvs=34680b893=kalyazin@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=34680b893=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757953130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3NeNyamqVLa9+DQCyzsj2cOhr41ZZd2MWu/K0OO1HI=;
	b=I1G3hkGr0zuNF8AM+0pNsXSwhDAjPo3QeEoq8KaxsRdppnb+Njj1yVAYe4bDCJUNGXZnmp
	24Ro0nc4GB4qmbsYNen38ErKT0tyFB453tvDJnPcgsvc49kYVflzCV3l2HYugdsLYSU2cw
	Jpt+GVqbAVQv47gJk+qY4P2fZMml6dE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=j7Kfrjvm;
	spf=pass (imf10.hostedemail.com: domain of "prvs=34680b893=kalyazin@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=34680b893=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757953130; a=rsa-sha256;
	cv=none;
	b=iT+R5xvaDOsVbXwdLt+TF8Cd/JkFO/NG6DhVUUMMjAYlTrYkwsrBmQqvAbLFtw3FDUm/87
	onl22zDsq57ku7+0E9ZhR054hrF7F4TugWQ0VARs1DoIwKBPytCUovcK2c24Ql7cE9qOTt
	gIs6jRGnmFKfhGXfXQFzOq9W3Xw2v2c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1757953130; x=1789489130;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N3NeNyamqVLa9+DQCyzsj2cOhr41ZZd2MWu/K0OO1HI=;
  b=j7KfrjvmRdp9obCrpQXNsmdhWJv88NNYyQptQTSwGTGxAPidBvzn5+6P
   9zTt+AqBOZYVw+divbWQiKGA0oGWNdPSzekwnweaKDb5jxp+FLMx2KRcW
   sWLcYURlp4h0S4zb3pGVOm8iGdF6HYCXXMQ2UR/KT/NINppCkelRUs9VW
   xZ/bmbJpYb403u/kKs5u3sxB04t31nvF7MGlpbPj4E07JXySKX4udcZBX
   PGNS9WMOkCZGIy8h7EDjV9rqXoGXWUqqb4tTpLT33gFHiStyJQNTfBCCl
   9UNxCa5gqwhAqKJNfQJU5dR5fVcj0f95SA0pBa4UMC5qMSvnczjrMhmQv
   Q==;
X-CSE-ConnectionGUID: ZcEgW1YvT0C2GF/FYjPcxw==
X-CSE-MsgGUID: IfTURVlRSXKEJ320dW9aJQ==
X-IronPort-AV: E=Sophos;i="6.18,266,1751241600"; 
   d="scan'208";a="2137065"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 16:18:40 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:25479]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.0.240:2525] with esmtp (Farcaster)
 id f857cdf3-c4a1-44e0-903b-97f2c9bca60f; Mon, 15 Sep 2025 16:18:40 +0000 (UTC)
X-Farcaster-Flow-ID: f857cdf3-c4a1-44e0-903b-97f2c9bca60f
Received: from EX19D022EUC004.ant.amazon.com (10.252.51.159) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 15 Sep 2025 16:18:39 +0000
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19D022EUC004.ant.amazon.com (10.252.51.159) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 15 Sep 2025 16:18:39 +0000
Received: from EX19D022EUC002.ant.amazon.com ([fe80::bd:307b:4d3a:7d80]) by
 EX19D022EUC002.ant.amazon.com ([fe80::bd:307b:4d3a:7d80%3]) with mapi id
 15.02.2562.020; Mon, 15 Sep 2025 16:18:39 +0000
From: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "brauner@kernel.org"
	<brauner@kernel.org>
CC: "peterx@redhat.com" <peterx@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "willy@infradead.org" <willy@infradead.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"jack@suse.cz" <jack@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "jthoughton@google.com"
	<jthoughton@google.com>, "tabba@google.com" <tabba@google.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring,
 Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Subject: [RFC PATCH v6 2/2] userfaulfd: add minor mode for guestmem
Thread-Topic: [RFC PATCH v6 2/2] userfaulfd: add minor mode for guestmem
Thread-Index: AQHcJlxlJ76MA28SOEel205dRdsXkA==
Date: Mon, 15 Sep 2025 16:18:39 +0000
Message-ID: <20250915161815.40729-3-kalyazin@amazon.com>
References: <20250915161815.40729-1-kalyazin@amazon.com>
In-Reply-To: <20250915161815.40729-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: wbyj9df7h5tbg3s71m74yq1enyt476q7
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E3D1C0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1757953130-382820
X-HE-Meta: U2FsdGVkX18JelySXwgGtvvtzYXt4xSTgJcDBrp3n0myAREOl3yJUF/hha2KFi6+6lSTnRpfCz2WvCvL2dAAFqrgMNfspbfVfHJqNZPi2+GB+pVGlcdYwXP0K/o8LyxAuVhRvPS/1yETd/bNGBT6h9qApsPGJXifyr3xuJojTh1HiKvEKxczo0ZqgnRMRJ7qLok5eu4HuF5Zm3CizhOXuDrq7Ihf+8Xy7oNqMTwDP9kkzVhfOUIHA0d5zVLqSnbHuserHdnW8kh/2moMk7JyEH8j3vG9U7VdQwQXSc6abjA5LR5QfiUcmTCK1i6gRIBG7V7CI0AjAOeIHhVpdlwQwLq37SJT95JElUJnum8N4aXu+mhxrEy0jAs2qTfV7WbI+7EvdSSNqTvAZSYNpCxsYtGrJErOuaeen32LEIsAXZ8W+36vgcakWkkAIiaVl6dgQ1P+hSwxZz3sq9SzbGimrGnu7WEOW1oMvls13UeJ6VApLkxM44xjE3Kl5E62LOsIkjHurHuVIoTGoMVYuVZHBlmZZbHf/VtsNAH1zemUAvSYEyW4fh93VOXZdDeL9oVxozHCmey220N9M0drpMl5drzPk1nCxNhIZLFj0jU2s48oVH2Xtxg5PNKFvik6lVWQ/HD746I4BhSr4f0Lxnwt07fZ4NFQydDWm7O1WA9I3edJNvqGgpcQk3+sIPkSE/Uk19C7FZNYnpulCe+u3soViGeovPJBzaFx3sQjooUKLvdjyIwZc5i9U5IkBcCpZHNj0TxCmnfShSL39/+wLJWdIWcFgYrXP8/C9i7Z8kgPqGjpmqLuH8Og0GFOgkiGnaHYeFncCudsaQNQctwqx7dfyfNz+CcFuCtNby09bBkZLz0q19XjVrIGxm0NmuwnnsFEUz9B/fXQeU78VpicdDL4ENeSeU3vVRjnqC/cyFJBWf3ykqaziMm9wW+j5xt5xJwisYcUhot75w4qqMwVDUN
 lnsNiQrq
 40o4+3sn/oFmTnvfxgk0kc9Es4GjGw+QZRbUBg2/kGxjQsVSIrJrVrB3jnx8ioVkPBg+Zc5Nf3fIb3VlS6AyTkCJLePw5oCA95AcxojvhT3nvkW7XlEZbpDQ1TlkUC/kKL6NqRg2RHYLLRKS+qDgDqbUlct/7g8ayNeCE/getCF2l4sqProf/FTKWTW+3lmHsZrxq05nHjoduWSLsIwZG1s9B+Pd0RkrwhzDZLN3NTxae4TO6etUT6a686j3LmmpWzRT/xJdrUBTMj6YH0VygwCs1z4Ufd/6uHM8t7dFNE1pEqwiQCYlb6dIBc5E47c8RrX9GirJvYtwOT0zfck0dEJnZYeOKzHOcFVnBbWbUWYSFTx9kyzd0wJzUdinVPnu5CTg+ni431nET3bhZkx1/mL3xBt+kbXx49lEV1Z2NNRUcDHmTLqRObwq3z96phgxZMXClsFQByuTsMndZb0AjwLeY7atZg4b39X/92VceXpJacwzg2OTDKqEbV+CoWz4jWZvYKpXq5F55jeJeSXbjra5m4I6nyBf1fqPsNsvm/cVniESolwzvhLP4nZ02S2OBmd8qqVchtmgBvkzRGAmIB8VkqK0sTu1SR0MQ/DxDzAk1QIGHF3ekuUvYgmWyurNc1vWtGcl9t/HYh5SwakKXj9rsZ6DOr0Aro6m822yto+CxLjM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>=0A=
=0A=
UserfaultFD support in guestmem enables use cases like restoring a=0A=
guest_memfd-backed VM from a memory snapshot in Firecracker [1] where an=0A=
external process is responsible for supplying the content of the guest=0A=
memory or live migration of guest_memfd-backed VMs.=0A=
=0A=
[1] https://github.com/firecracker-microvm/firecracker/blob/main/docs/snaps=
hotting/handling-page-faults-on-snapshot-resume.md=0A=
=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 Documentation/admin-guide/mm/userfaultfd.rst |  4 +++-=0A=
 fs/userfaultfd.c                             |  3 ++-=0A=
 include/linux/userfaultfd_k.h                |  8 +++++---=0A=
 include/uapi/linux/userfaultfd.h             |  8 +++++++-=0A=
 mm/userfaultfd.c                             | 14 +++++++++++---=0A=
 5 files changed, 28 insertions(+), 9 deletions(-)=0A=
=0A=
diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/a=
dmin-guide/mm/userfaultfd.rst=0A=
index e5cc8848dcb3..ca8c5954ffdb 100644=0A=
--- a/Documentation/admin-guide/mm/userfaultfd.rst=0A=
+++ b/Documentation/admin-guide/mm/userfaultfd.rst=0A=
@@ -111,7 +111,9 @@ events, except page fault notifications, may be generat=
ed:=0A=
 - ``UFFD_FEATURE_MINOR_HUGETLBFS`` indicates that the kernel supports=0A=
   ``UFFDIO_REGISTER_MODE_MINOR`` registration for hugetlbfs virtual memory=
=0A=
   areas. ``UFFD_FEATURE_MINOR_SHMEM`` is the analogous feature indicating=
=0A=
-  support for shmem virtual memory areas.=0A=
+  support for shmem virtual memory areas. ``UFFD_FEATURE_MINOR_GUESTMEM``=
=0A=
+  is the analogous feature indicating support for guestmem-backed memory=
=0A=
+  areas.=0A=
 =0A=
 - ``UFFD_FEATURE_MOVE`` indicates that the kernel supports moving an=0A=
   existing page contents from userspace.=0A=
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c=0A=
index 54c6cc7fe9c6..e4e80f1072a6 100644=0A=
--- a/fs/userfaultfd.c=0A=
+++ b/fs/userfaultfd.c=0A=
@@ -1978,7 +1978,8 @@ static int userfaultfd_api(struct userfaultfd_ctx *ct=
x,=0A=
 	uffdio_api.features =3D UFFD_API_FEATURES;=0A=
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=0A=
 	uffdio_api.features &=3D=0A=
-		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM);=0A=
+		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM |=0A=
+		  UFFD_FEATURE_MINOR_GUESTMEM);=0A=
 #endif=0A=
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP=0A=
 	uffdio_api.features &=3D ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;=0A=
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h=
=0A=
index c0e716aec26a..37bd4e71b611 100644=0A=
--- a/include/linux/userfaultfd_k.h=0A=
+++ b/include/linux/userfaultfd_k.h=0A=
@@ -14,6 +14,7 @@=0A=
 #include <linux/userfaultfd.h> /* linux/include/uapi/linux/userfaultfd.h *=
/=0A=
 =0A=
 #include <linux/fcntl.h>=0A=
+#include <linux/guestmem.h>=0A=
 #include <linux/mm.h>=0A=
 #include <linux/swap.h>=0A=
 #include <linux/swapops.h>=0A=
@@ -218,7 +219,8 @@ static inline bool vma_can_userfault(struct vm_area_str=
uct *vma,=0A=
 		return false;=0A=
 =0A=
 	if ((vm_flags & VM_UFFD_MINOR) &&=0A=
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))=0A=
+	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma) &&=0A=
+		!guestmem_vma_is_guestmem(vma)))=0A=
 		return false;=0A=
 =0A=
 	/*=0A=
@@ -238,9 +240,9 @@ static inline bool vma_can_userfault(struct vm_area_str=
uct *vma,=0A=
 		return false;=0A=
 #endif=0A=
 =0A=
-	/* By default, allow any of anon|shmem|hugetlb */=0A=
+	/* By default, allow any of anon|shmem|hugetlb|guestmem */=0A=
 	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||=0A=
-	    vma_is_shmem(vma);=0A=
+	    vma_is_shmem(vma) || guestmem_vma_is_guestmem(vma);=0A=
 }=0A=
 =0A=
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct =
*vma)=0A=
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaul=
tfd.h=0A=
index 2841e4ea8f2c..0fe9fbd29772 100644=0A=
--- a/include/uapi/linux/userfaultfd.h=0A=
+++ b/include/uapi/linux/userfaultfd.h=0A=
@@ -42,7 +42,8 @@=0A=
 			   UFFD_FEATURE_WP_UNPOPULATED |	\=0A=
 			   UFFD_FEATURE_POISON |		\=0A=
 			   UFFD_FEATURE_WP_ASYNC |		\=0A=
-			   UFFD_FEATURE_MOVE)=0A=
+			   UFFD_FEATURE_MOVE |			\=0A=
+			   UFFD_FEATURE_MINOR_GUESTMEM)=0A=
 #define UFFD_API_IOCTLS				\=0A=
 	((__u64)1 << _UFFDIO_REGISTER |		\=0A=
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\=0A=
@@ -230,6 +231,10 @@ struct uffdio_api {=0A=
 	 *=0A=
 	 * UFFD_FEATURE_MOVE indicates that the kernel supports moving an=0A=
 	 * existing page contents from userspace.=0A=
+	 *=0A=
+	 * UFFD_FEATURE_MINOR_GUESTMEM indicates the same support as=0A=
+	 * UFFD_FEATURE_MINOR_HUGETLBFS, but for guestmem-backed pages=0A=
+	 * instead.=0A=
 	 */=0A=
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)=0A=
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)=0A=
@@ -248,6 +253,7 @@ struct uffdio_api {=0A=
 #define UFFD_FEATURE_POISON			(1<<14)=0A=
 #define UFFD_FEATURE_WP_ASYNC			(1<<15)=0A=
 #define UFFD_FEATURE_MOVE			(1<<16)=0A=
+#define UFFD_FEATURE_MINOR_GUESTMEM		(1<<17)=0A=
 	__u64 features;=0A=
 =0A=
 	__u64 ioctls;=0A=
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c=0A=
index 45e6290e2e8b..304e5d7dbb70 100644=0A=
--- a/mm/userfaultfd.c=0A=
+++ b/mm/userfaultfd.c=0A=
@@ -388,7 +388,14 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,=
=0A=
 	struct page *page;=0A=
 	int ret;=0A=
 =0A=
-	ret =3D shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);=0A=
+	if (guestmem_vma_is_guestmem(dst_vma)) {=0A=
+		ret =3D 0;=0A=
+		folio =3D guestmem_grab_folio(inode->i_mapping, pgoff);=0A=
+		if (IS_ERR(folio))=0A=
+			ret =3D PTR_ERR(folio);=0A=
+	} else {=0A=
+		ret =3D shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);=0A=
+	}=0A=
 	/* Our caller expects us to return -EFAULT if we failed to find folio */=
=0A=
 	if (ret =3D=3D -ENOENT)=0A=
 		ret =3D -EFAULT;=0A=
@@ -766,9 +773,10 @@ static __always_inline ssize_t mfill_atomic(struct use=
rfaultfd_ctx *ctx,=0A=
 		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,=0A=
 					     src_start, len, flags);=0A=
 =0A=
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))=0A=
+	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma)=0A=
+	    && !guestmem_vma_is_guestmem(dst_vma))=0A=
 		goto out_unlock;=0A=
-	if (!vma_is_shmem(dst_vma) &&=0A=
+	if (!vma_is_shmem(dst_vma) && !guestmem_vma_is_guestmem(dst_vma) &&=0A=
 	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))=0A=
 		goto out_unlock;=0A=
 =0A=
-- =0A=
2.50.1=0A=
=0A=


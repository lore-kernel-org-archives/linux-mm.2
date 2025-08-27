Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37DDECA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E7E8E0143; Wed, 27 Aug 2025 07:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835D98E0105; Wed, 27 Aug 2025 07:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7728D8E0143; Wed, 27 Aug 2025 07:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63CF28E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:40:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C9B91DE2B2
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:40:35 +0000 (UTC)
X-FDA: 83822344830.15.D97F272
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4B84EA0009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:40:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gMihoJ8C;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756294833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XeoM2pRAda8SuuPICRFUFFSQ54mI0ws6ytKPaFfrQVE=;
	b=cKvu0M+RGi7CBLyxIWkbauf3ceR8OPza8wgwBht9LHkoizhbM2d63PwCnYiAWXAEykHssu
	FmpzWkdUT88x+gE7bwUs7NvxJ0BFvbrncURznrm6mQh0P9Xev4Tb6Zbdw1U+mQJ2OQs6oF
	c4pyHBzKgvvbMR+OvNoicq+7vNmZ6Bk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gMihoJ8C;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756294833; a=rsa-sha256;
	cv=none;
	b=pqcCcIFAMsroTTYip6dnk+pguKNlZXEUV84vQzZP6C8OW1uyvyFry3ZOXXdG2zjBQt5cdd
	SrHshwJerPc5EAtYPvrhDrbv9kG9E0utHz33RXd9nHgllQ5D2PdPWK0blmDzr/5qPvvhuB
	klIbIxzXZKiVdMEAWSImHaeIm60Ka1Y=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-70a88de7d4fso57985906d6.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756294832; x=1756899632; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XeoM2pRAda8SuuPICRFUFFSQ54mI0ws6ytKPaFfrQVE=;
        b=gMihoJ8CjFynmn3tlgiMgj/bovKbshQQ9B72WCtBemVM+NJoosMfvnycalOhVbFt69
         tUH7dWZm/oBTqNCFh53K4mCwe1MEYDTASVpfpuQEQCSNwxqnXwRTQbMcuTW8rQElOVHv
         PTyHXo/Ht/UOXQD1EUyvzkLKF0RCjrbyhb635NrC996FcPiC12DQkw+HJrw+/+oZcnM/
         ae6KMEqHGAx9uFH8VHKx/6tlF0ZXaKJlasePnWSiH9GzSUnwdYR6HpOYEL/8qveHVpA/
         voQotWAsK7GS41vc1ut0uRjdybkG4lb6D2Woxdc5F8KtB/vlrzkx9vXL0f2ctrsEZS7Q
         ZDmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756294832; x=1756899632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XeoM2pRAda8SuuPICRFUFFSQ54mI0ws6ytKPaFfrQVE=;
        b=C4b2wxor5Jm2cxdPf2qwxAWlvhuev7TkboxsiOIwsfm1f9ewZHjs1RCKFTd+ZC24Lo
         3T+9bmThC1f2Aqd6Lwm5/YleIaxKxbeHLGFcUgN7tSq4KcNHSMr92r4SCBYFKEDAo22r
         Ax++IeRjmoDX8UmpF1XZs84TVYtJE8AhB82dCjNc7GWvQJWjpQ2MU9wRzJw+uXWLvDeZ
         fEwT5z3c11XQDECwZMexHXOXXj1HX2aLYr3YJw8mTfDp7anXqa5Hw4iheaZYEqou/LE6
         dH+jXpYAZA7UUlgcYEw7kjFIrIk97HLWYR8xhQj7oW0NyMdQPgDGDRH8/FdXXRKdiXlK
         o84g==
X-Forwarded-Encrypted: i=1; AJvYcCWYDJbUPNHT7O7UJXoktAxXtPiZFw9KNca5+vPun6HG0AqAw9OlyeJc9B8SI3csUhbj85Ivf8t0ig==@kvack.org
X-Gm-Message-State: AOJu0YwpXwAROBPD6cdml4XbykFINaFd+VXwMPWR2p3FIHMTfIukR9gE
	ANTrBr2FPrFoUz7tgMFVlTH9bPjNYPB19s+bifImhfhNxFfHfjwTmd4ftqWZTBQjllpjz7oMT4O
	BgU6EKopwFQhZtN1Yx7yKebLO80A9KKU=
X-Gm-Gg: ASbGncuy3BP8kXrjoyLDkibhZ/1yasXUOmsPmU3fyCDrt9kScwmjgT3EL4qUOUgRajc
	BfK4nwdxJWgge9ZYYlY05Uupwns9itphlrmx2ULPa+yBiJeaIgiTlvrUripSGdnrkO4hpEGnrR1
	47WJtTdrLcQepyv/W40qVj+uqfenuiHMbfECmh+RHcuxYtNTMbViGrC6B3ZiEYH2UtJN25qa8Ck
	uoKxFfWkgARQH21QYI1UFfVDMTa1aqiV+pCWeDtIE7TYwkCA+g=
X-Google-Smtp-Source: AGHT+IELLrqV3R85XBc6agU/7DzAWxsj82fvVPd+3fVYozs8/RRKK8VEk3bA7WWCc4E5Pk4l/H0YX2Fkq99QBUTmqQk=
X-Received: by 2002:ad4:5cab:0:b0:708:1296:c5ab with SMTP id
 6a1803df08f44-70d971e4042mr226760146d6.34.1756294832315; Wed, 27 Aug 2025
 04:40:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-2-laoar.shao@gmail.com> <202508271009.5neOZ0OG-lkp@intel.com>
In-Reply-To: <202508271009.5neOZ0OG-lkp@intel.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 27 Aug 2025 19:39:55 +0800
X-Gm-Features: Ac12FXwZr66D7NPE9H9ynH6vKXzl7w2VfiSW67LSXeqGM2TeN__rIRX4dJec3k8
Message-ID: <CALOAHbCtE-Sjeja3gzGwooWcikGWetPj8k6wqk52_c0hEo5ZKQ@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 01/10] mm: thp: add support for BPF based THP
 order selection
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, oe-kbuild-all@lists.linux.dev, 
	bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bo4qda4yawm1qxux3fqmyobp4h899czp
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B84EA0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756294833-397374
X-HE-Meta: U2FsdGVkX19as2f/EKF/Zt+vKLcdljZoTmx39ZiofgTqfVXC+dVyb+FuQMWOz1OBZRLsHV3lBNIItzoV8AApihfWyhuG4MHmWuQ3JCO++Vbe/Gu9VX49MBikafWBOLaYrm7zabjOToscFwuBrDMH0fgEBJR41JCUAw3sjvuDDYRruMSdX+oIoVDDdGZ0id37eIEnFIjWAg+3RDei7L3VI71r5fN1mO+XJkq9LHR9ypRQQZmqa2UuDKJcfRVCAumGB8cdOHHeOn4nAAAbPvbOvsD9VulxmOwHxK5S825eQaxqZdeG1wa141t1MCszAQ4QtH/0jJXW7ZS2QX49OSTjSC0GF/gRdMGRgoCm38a5O8cMvoTgJ0bpUX0x3VCaAZNi0uw7efDYsTVcg6ipWsSMv2etGYtBVcdalQrAx6zA0hJWoiOpSe5r2iCscSOSimRtw8QRp0+yBeahjYW8R6oy6+F+1gGwHpEhAhHh3qHIJepllOuBBmweXlrMMHPJQxYwTHMqUu3Uug2SYgH9eXxkCpM9aFrqY4N5hbB0hpB4IlaL1xV8uJLP9aC1jxvrtlOrDXhJDqm+Mz3VAX15kbDLIldc+bNhdowweDEVk0RraMZy31jki1ulR0MzFnmCZOJ1b2nyDjNb+fg0Rcg0+ziMn2WUl5luZ4d5+Vgwb4v/xhZTX2v17i3uuiOCC5SCvmTPZgeATZ8zXDcLGQ4qbzAsXH6X9byapH99jSCoyqM8w0//WuI5s76jBVzGsHi5Lrx8LOS72oLX00r9gSeP1S27q2bz/nsjZKGkhcBjsTZRTCjz+z6HoOruXL2NtvrxjQGfWV4RlYQcBIOQ9Fxyy/Z9Ye+Dwagf3+8h2Jrro4AhzmX7+W9Y4gmZwRgoOULyYYc73SAFntyDtjmEysX0F5eGOx3Pg35pzqsakJ76ffMwHvyibboRi4+wlUHYGKz3kDAyDXLalY5buQL2kJB9yHd
 H0eON5Er
 ou03m7euTLjFqukThQrL5xLI6w4JeefgNTiYNqMhbg4FCwmV7SfXNBFlgX0QnggoErdXXAKKK39H+uUtjWJWon3IfgIpBap0cCscAvDdtOTM+EcQk+97jw4djNFIV583Kj5YH6ZOHqcT3oyG59XAJ309ppR/9axKTGkxZtCcDYTXvZ3nooVD9/2QgbtFas3OnvPVVdlzJW0iwM4bUO0JJrda0PnNV+gy7YZXg7g5dH4Mt5VABKX38SZrjgkCzPsHufYQvfZ+P0jirovAElU+L15TKXrSJi6gsPqGJJaPgYSZ3yqBH7LLoQF++n1tHF6e/GrLa5RLd2V3teWx6O6ocxjmHNWLiUL1oVPuT6Rnvank+v2w83g1EiU0PtdzO8GTd/O6qpnT2QWB0lyq9fdzo1lqAGwlpD6yh5gBOtMwA7oDLDUUj8ROws9q5+/K2LjjWGGZXSKdgsKgFn2Hn8IBvMs1N3z0WXIfAXfOJbwVO/yPZvvU9ofIqBEQlt8zANfkIrRoFdEqwEv2OmY84AuFgl2funOgurhXMHwVx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 10:58=E2=80=AFAM kernel test robot <lkp@intel.com> =
wrote:
>
> Hi Yafang,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on akpm-mm/mm-everything]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Yafang-Shao/mm-thp=
-add-support-for-BPF-based-THP-order-selection/20250826-152415
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-ev=
erything
> patch link:    https://lore.kernel.org/r/20250826071948.2618-2-laoar.shao=
%40gmail.com
> patch subject: [PATCH v6 mm-new 01/10] mm: thp: add support for BPF based=
 THP order selection
> config: loongarch-randconfig-r113-20250827 (https://download.01.org/0day-=
ci/archive/20250827/202508271009.5neOZ0OG-lkp@intel.com/config)
> compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b=
5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
> reproduce: (https://download.01.org/0day-ci/archive/20250827/202508271009=
.5neOZ0OG-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508271009.5neOZ0OG-lkp=
@intel.com/

Thanks for the report .
It seems this sparse warning can be fixed with the below additional
change, would you please test it again?

diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
index 46b3bc96359e..b2f97f9e930d 100644
--- a/mm/bpf_thp.c
+++ b/mm/bpf_thp.c
@@ -5,27 +5,32 @@
 #include <linux/huge_mm.h>
 #include <linux/khugepaged.h>

+/**
+ * @get_suggested_order: Get the suggested THP orders for allocation
+ * @mm: mm_struct associated with the THP allocation
+ * @vma__nullable: vm_area_struct associated with the THP allocation
(may be NULL)
+ *                 When NULL, the decision should be based on @mm (i.e., w=
hen
+ *                 triggered from an mm-scope hook rather than a VMA-speci=
fic
+ *                 context).
+ *                 Must belong to @mm (guaranteed by the caller).
+ * @vma_flags: use these vm_flags instead of @vma->vm_flags (0 if @vma is =
NULL)
+ * @tva_flags: TVA flags for current @vma (-1 if @vma is NULL)
+ * @orders: Bitmask of requested THP orders for this allocation
+ *          - PMD-mapped allocation if PMD_ORDER is set
+ *          - mTHP allocation otherwise
+ *
+ * Rerurn: Bitmask of suggested THP orders for allocation. The highest
+ *         suggested order will not exceed the highest requested order
+ *         in @orders.
+ */
+typedef int suggested_order_fn_t(struct mm_struct *mm,
+                                struct vm_area_struct *vma__nullable,
+                                u64 vma_flags,
+                                enum tva_type tva_flags,
+                                int orders);
+
 struct bpf_thp_ops {
-       /**
-        * @get_suggested_order: Get the suggested THP orders for allocatio=
n
-        * @mm: mm_struct associated with the THP allocation
-        * @vma__nullable: vm_area_struct associated with the THP
allocation (may be NULL)
-        *                 When NULL, the decision should be based on
@mm (i.e., when
-        *                 triggered from an mm-scope hook rather than
a VMA-specific
-        *                 context).
-        *                 Must belong to @mm (guaranteed by the caller).
-        * @vma_flags: use these vm_flags instead of @vma->vm_flags (0
if @vma is NULL)
-        * @tva_flags: TVA flags for current @vma (-1 if @vma is NULL)
-        * @orders: Bitmask of requested THP orders for this allocation
-        *          - PMD-mapped allocation if PMD_ORDER is set
-        *          - mTHP allocation otherwise
-        *
-        * Rerurn: Bitmask of suggested THP orders for allocation. The high=
est
-        *         suggested order will not exceed the highest requested or=
der
-        *         in @orders.
-        */
-       int (*get_suggested_order)(struct mm_struct *mm, struct
vm_area_struct *vma__nullable,
-                                  u64 vma_flags, enum tva_type
tva_flags, int orders) __rcu;
+       suggested_order_fn_t __rcu *get_suggested_order;
 };

 static struct bpf_thp_ops bpf_thp;
@@ -34,8 +39,7 @@ static DEFINE_SPINLOCK(thp_ops_lock);
 int get_suggested_order(struct mm_struct *mm, struct vm_area_struct
*vma__nullable,
                        u64 vma_flags, enum tva_type tva_flags, int orders)
 {
-       int (*bpf_suggested_order)(struct mm_struct *mm, struct
vm_area_struct *vma__nullable,
-                                  u64 vma_flags, enum tva_type
tva_flags, int orders);
+       suggested_order_fn_t *bpf_suggested_order;
        int suggested_orders =3D orders;

        /* No BPF program is attached */
@@ -106,10 +110,12 @@ static int bpf_thp_reg(void *kdata, struct bpf_link *=
link)

 static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
 {
+       suggested_order_fn_t *old_fn;
+
        spin_lock(&thp_ops_lock);
        clear_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
&transparent_hugepage_flags);
-       WARN_ON_ONCE(!rcu_access_pointer(bpf_thp.get_suggested_order));
-       rcu_replace_pointer(bpf_thp.get_suggested_order, NULL,
lockdep_is_held(&thp_ops_lock));
+       old_fn =3D rcu_replace_pointer(bpf_thp.get_suggested_order,
NULL, lockdep_is_held(&thp_ops_lock));
+       WARN_ON_ONCE(!old_fn);
        spin_unlock(&thp_ops_lock);

        synchronize_rcu();
@@ -117,8 +123,9 @@ static void bpf_thp_unreg(void *kdata, struct
bpf_link *link)

 static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link *l=
ink)
 {
-       struct bpf_thp_ops *ops =3D kdata;
+       suggested_order_fn_t *old_fn, *new_fn;
        struct bpf_thp_ops *old =3D old_kdata;
+       struct bpf_thp_ops *ops =3D kdata;
        int ret =3D 0;

        if (!ops || !old)
@@ -130,9 +137,10 @@ static int bpf_thp_update(void *kdata, void
*old_kdata, struct bpf_link *link)
                ret =3D -ENOENT;
                goto out;
        }
-       WARN_ON_ONCE(!rcu_access_pointer(bpf_thp.get_suggested_order));
-       rcu_replace_pointer(bpf_thp.get_suggested_order,
ops->get_suggested_order,
-                           lockdep_is_held(&thp_ops_lock));
+
+       new_fn =3D rcu_dereference(ops->get_suggested_order);
+       old_fn =3D rcu_replace_pointer(bpf_thp.get_suggested_order,
new_fn, lockdep_is_held(&thp_ops_lock));
+       WARN_ON_ONCE(!old_fn || !new_fn);

 out:
        spin_unlock(&thp_ops_lock);
@@ -159,7 +167,7 @@ static int suggested_order(struct mm_struct *mm,
struct vm_area_struct *vma__nul
 }

 static struct bpf_thp_ops __bpf_thp_ops =3D {
-       .get_suggested_order =3D suggested_order,
+       .get_suggested_order =3D (suggested_order_fn_t __rcu *)suggested_or=
der,
 };

 static struct bpf_struct_ops bpf_bpf_thp_ops =3D {


--
Regards

Yafang


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C736FF3D5FE
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 09:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2CA36B008C; Sun, 29 Mar 2026 05:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04016B0095; Sun, 29 Mar 2026 05:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40BA6B0096; Sun, 29 Mar 2026 05:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B15066B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 05:27:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4998E160428
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:27:39 +0000 (UTC)
X-FDA: 84598573038.26.0842984
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4FC4720007
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:27:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FMha2kUr;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774776457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEHkLhpLN9BJCSGtTIfOJIo17BtlLLKI1kfp4Hozo9g=;
	b=6RQDzb2jDS/HIxRogvMEndFIsA8rSJjNsOKtW6rfjjMzs7pEag4XkXNu3OdeDqGR7d304g
	jL2f7Q02lLaQdFkKKTuERxIPK7JqSBP9R7BipTN05tcTgRy13+VNpiWeaQPo6asaIYKmsu
	vhJe5CE9fBpqUehkQeY41QTT8aY4CLc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FMha2kUr;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774776457; a=rsa-sha256;
	cv=none;
	b=vs65eao3/zeQKVB9wUwVKh2O/mLzw14hFX35CbwwakLN5DG6QwGpnvuHaBdDGJytkqi6Up
	fR2ULJ0dLBON4UtcBom473YVrJg7tfxE0oSXeN9mXsev5xG6DQ41vP6k3imYYOlHtnPUrB
	y0Nh7HKZRS2SiewzVUSNMBo6lfwCsvY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774776456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YEHkLhpLN9BJCSGtTIfOJIo17BtlLLKI1kfp4Hozo9g=;
	b=FMha2kUrTo312bnHQ+bAPGu7+5gNeoaDxUY1NmRTcZBGxB0D4d+97xT1gso7yzTxzjV00B
	VHUxeLO/C3JSlfKwmoWPBd/tjGpIxPOgFM2W6QLH+cUioserObW0F+2pytMkUNxiNe3VcE
	75EggAoh9KaGXxvF61piSvlSwaSPm/o=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-iXW6Oc3oMs2_m6qiq-31ZA-1; Sun,
 29 Mar 2026 05:27:31 -0400
X-MC-Unique: iXW6Oc3oMs2_m6qiq-31ZA-1
X-Mimecast-MFC-AGG-ID: iXW6Oc3oMs2_m6qiq-31ZA_1774776449
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C4281800344;
	Sun, 29 Mar 2026 09:27:28 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.11])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6265319560B1;
	Sun, 29 Mar 2026 09:27:17 +0000 (UTC)
Date: Sun, 29 Mar 2026 17:27:13 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v6 4/6] selftests/mm/vm_util: robust write_file()
Message-ID: <acjwcQjCP81JldAX@gmail.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
 <20260324013316.2590422-5-chuhu@redhat.com>
 <acZ4wTxSmPn_s_mn@kernel.org>
MIME-Version: 1.0
In-Reply-To: <acZ4wTxSmPn_s_mn@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: aXgo_Jx8WjZ9iIS_-Vqnfmaftxp-pBFbT350Kb3rHwg_1774776449
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: 54twb39qekrpboocos5u61rizaj9hb8r
X-Rspamd-Queue-Id: 4FC4720007
X-Rspamd-Server: rspam09
X-HE-Tag: 1774776457-122104
X-HE-Meta: U2FsdGVkX1+vDW0ps9baglxsziie0XLhKtUHDUB7Q5VpSYdjyUAeltc6a23bpq0/eBR50Utl2N4C0zOYDceiZG132AqJ8yEVOeIW/Z4bmfwwLd2pTCobFYbxBhvt5yetTIpMuNQFKPzer9jrh1ztBldo8zr1cQv0CSMrBvtVl/S8m+v7ds3xGL+mzoGIj3fPMURD9EtAMaMomv05MBkVSACO/DeKHtXqG0Vs09hC/02U2IDX4HGbhJy02CU/hFrUqdtYodGmAZ1iogLdf2y5IzGIW5IHCNvk4zEoyipvvTC2c4UfgMEi2TPvSSu9eHgQgLcV+t22Nh+1NiDVpcevzOxPqBvr0zrKt5dOJ1Xhdf2pvMcy4MYPuesZTw+6aNg6Yf/Vm1/QKOGx1X4oKXkJAy9tPb9f+KEIZD4hlWQoQQwDkrF69DQK8zbAQFK9j7ZtHFM7u6jCmfXeIg6N2bg8oCccNCiB5bgqNPL24otv96wSBHiH1Zk5797MTZ2wn4qWRk7rkmPlueVj2fftEUCzSgqW7kd6JDClo4Bw7H9ArNB/S9ZJ+n0L3QvE01rKL0FhZzm6P6XdFlTmacxHCUyXQXq4Q8o6Ba2bzIr2x0OBzhw0feGaCDMQ8GROkXdTg23wkDGMQZoNpIiVMbQe/qCe92d+MaSGYu8x1bLzhCpOifzo9XxA8p2Dz5rIrg1qwF7Vj3y39I0x9N3COxvZ2LD6zsYpiMCqUu0Ug1JlVSnrQlZUMQr/6j7Uc9o9xyloDYRWAoXpDG6rx9Sk1/RJqrN5qfQA0RRtaniH1YtY280UsnHADdmZI6c2CNWZ3ReFJ1Z/hcsfmoRQnBx5HjwBw+U3MB6UkcmvW2/Vkzd+wZQvebb8gjtTeA02I0Vff9Ba9z8nKR9ETDLHj3APT+Dz4XRS7br3LAamokr3c7XOmMBaKr6WQUCv9T3L7ldTL2xviQoxuVYtipU9G4xlU2cM9E4
 3nQU4qAc
 BFWzlhnP4e9vdK6HXM92tMxpjplxN0k3uVIilPrM8kT5yisJlt+uPSM+OsboXdUB04e9aCdr2dl+l+Up+T7a1hLwPfVe30/sHA7M4IQefiPCrGSD99RyQvsZL3dF5BbNMw84+/3y4oD0mLDSzumnHaGlzhnpqRjhvM/K4Z7isx+EpzqwFryfrWxCz0iTXeFRAJBw2T6pmvE2uip4BsxT5Bhpck8Z3+eY6MykGzcZ43GKfVsBrkVHebBQLZDNe0w2+SqCcKjJQXwkBrZ1FyjYFZSbcbAxopMwSUCDH3rDOSuKTHQJamSVmhapF1TtsOzulHem/rGgPFis5ZLn5RX0sGdTRvpuP5K1jbmG6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 03:32:01PM +0300, Mike Rapoport wrote:
> On Tue, Mar 24, 2026 at 09:33:14AM +0800, Chunyu Hu wrote:
> > Add two more checks for buflen and numwritten. The buflen should be at
> > least one, otherwise the 'buflen - 1' could underflow and cause trouble.
> > The numwritten should be equal to 'buflen - 1'. The test will exit if
> > any of these conditions aren't met.
> > 
> > Additionally, add more print information when a write failure occurs or
> > a truncated write happens, providing clearer diagnostics.
> > 
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > ---
> > Changes in v6:
> >   - save/restore errno before and after the close(), so the log could show
> >     the correct error info on failure. Suggested by AI.
> > Chagnes in v5:
> >   - new patch for making improve on write_file. Add more safety checks and
> >     diagnostics info in log
> > ---
> >  tools/testing/selftests/mm/vm_util.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index ad96d19d1b85..572ccb99de8e 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -767,15 +767,23 @@ int unpoison_memory(unsigned long pfn)
> >  
> >  void write_file(const char *path, const char *buf, size_t buflen)
> >  {
> > -	int fd;
> > +	int fd, saved_errno;
> >  	ssize_t numwritten;
> > +	if (buflen < 1)
> > +		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
> >  
> >  	fd = open(path, O_WRONLY);
> >  	if (fd == -1)
> >  		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
> 
> We have ksft_exit_fail_perror(), fits great here

the ksft_exit_fail_perror() don't accept the fmt string, it only accept
a single string as parameter.

```
static inline __noreturn void ksft_exit_fail_perror(const char *msg)

```

But we can change it also support va_list arg like 
ksft_exit_fail_msg(msg, ...) does:

static inline __noreturn void ksft_exit_fail_perror(msg, ...)

I can have a try in next version.

> 
> >  
> >  	numwritten = write(fd, buf, buflen - 1);
> > +	saved_errno = errno;
> >  	close(fd);
> > +	errno = saved_errno;
> >  	if (numwritten < 1)
> > -		ksft_exit_fail_msg("Write failed\n");
> > +		ksft_exit_fail_msg("%s write(%s) failed: %s\n", path, buf,
> > +				strerror(errno));
> 
> and here.

Same answer with above coment.

> 
> > +	if (numwritten != buflen - 1)
> > +		ksft_exit_fail_msg("%s write(%s) is truncated, expected %zu bytes, got %zd bytes\n",
> > +				path, buf, buflen - 1, numwritten);
> >  }
> > -- 
> > 2.53.0
> > 
> 
> -- 
> Sincerely yours,
> Mike.
> 



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF323D2F32D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2618A6B0005; Tue, 13 Jan 2026 14:21:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C1D6B0089; Tue, 13 Jan 2026 14:21:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121CD6B008A; Tue, 13 Jan 2026 14:21:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F258A6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:21:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BADC57A81
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:21:33 +0000 (UTC)
X-FDA: 84327909666.29.4864535
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id DB02B160009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:21:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CxsPEwlg;
	spf=pass (imf08.hostedemail.com: domain of 3OptmaQYKCF0N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3OptmaQYKCF0N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768332091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cd9IICRIq3DTaCVl8VXn5p++y32sGJCFM6gcMQfVFro=;
	b=emTKZ6GvmnjCj7dyZ7OAoE5LSXe2x/KRJPkmyUZM9c5tTJWsYiz1gWPujjI/MTlqzwWZU8
	H68KYkK3Xgs+sCbnjI8Vf9f5DT28zzQXxVuXflYp/L2kDpcAwFbWFVyxASfbreCeo9G5CM
	FA7726IgspqazcXqOpVYFP0drHWGKdE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CxsPEwlg;
	spf=pass (imf08.hostedemail.com: domain of 3OptmaQYKCF0N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3OptmaQYKCF0N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768332091; a=rsa-sha256;
	cv=none;
	b=SXFuX5cMHXTKt3LD7jhSwfWN+3pz9nx3mjJ9qkbyxByY1j+gVadeoCsPnxXq6NPw2fxfX4
	LVDm9+gtqW2vj92Qvji/NfNhMeAd0gOozwQ6u801dZPsszo6ohsgPz+m967Hp6v5eq+kL/
	lkoodyKCGPaovVze2kdxRl8FW3JmrRA=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c5d6193daso14687235a91.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768332091; x=1768936891; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cd9IICRIq3DTaCVl8VXn5p++y32sGJCFM6gcMQfVFro=;
        b=CxsPEwlgC10sMHY5lygDAdBZ/ALCrczM8DbXn586cACnItGHCYufDQq9t+ywFJxg3e
         bfGqEArWRLONcl55WE3mEWzu/7erWu6NwUJOrkY1IGb40iERyi6iOC9/s1SoDxXCaks5
         cFqTpuNoxIHVhOWD2wAQVQR6bo/n8F6dpsJFo4QXL3qEirYSNpCy1/MbFnu4mSbCwjEC
         jWNF3HvV7x9BdfvVjA4SzEfsFG1aya1pOvV241fcry3OKVigLxhwCBKdqIUC7YZNBfqq
         J3ljIsdEcKWa6ZhlZbOjOPi6bG965+tQ3/UF1aANh3H/y4f3gY1xAxrftwBQ5Vvpgxsn
         y0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768332091; x=1768936891;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cd9IICRIq3DTaCVl8VXn5p++y32sGJCFM6gcMQfVFro=;
        b=JROm4SVaoOpq3lmpyBf/IPtzulUYTIglqVFgbO/9Z0arCGEg0nKA6st6/9tUtyzNQU
         2MaD7kv51ReO0LEo7H6vWXHL0XAjkz/R0UO36z0ZDAk0dNAryqydP7mIA4UO+WRT2dVm
         cy/moDRv6XeIsG66VtdVM3GIUpXtXz8tdYallBHgcgXT6HGyaadbv1UpS/8baHkNap8B
         CV/sOauN6NW/CEWR/jP6/rVmjFhsDnjkJ4Slh1qtAPETFnKp2Jrq4DzXfZOBspftwPgb
         qlvlKes/7yUzAEShmG//hC/jV7o5LsBO1kG5DWRej943AFzDMftcrADt9Y4qmVBSFvov
         3rLw==
X-Forwarded-Encrypted: i=1; AJvYcCWTVrgbn92BxriTdkcPzCG6o9GIJbP9RblZChuORfeU5xaMKKXN1sHrdRT95lNKJjosQyXPEkTXuQ==@kvack.org
X-Gm-Message-State: AOJu0YwlzdxXDOf72JUyX1VSSCw1oZ6m6EA9d/OAFyC0uqzFUONad7n6
	nI66hitvBqF19HzrvLht+3jIAsNbt9flw/UgEsU8/CMAanqRPd16G3e8gvYYXVaGpBp+7Ypoxgx
	wjSuwPQ==
X-Received: from pjut11.prod.google.com ([2002:a17:90a:d50b:b0:349:3867:ccc1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d50:b0:341:8ac7:39b7
 with SMTP id 98e67ed59e1d1-3510913cc0dmr105362a91.25.1768332090565; Tue, 13
 Jan 2026 11:21:30 -0800 (PST)
Date: Tue, 13 Jan 2026 11:21:29 -0800
In-Reply-To: <20260108214622.1084057-7-michael.roth@amd.com>
Mime-Version: 1.0
References: <20260108214622.1084057-1-michael.roth@amd.com> <20260108214622.1084057-7-michael.roth@amd.com>
Message-ID: <aWabORpkzEJygYNQ@google.com>
Subject: Re: [PATCH v3 6/6] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	vbabka@suse.cz, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	david@redhat.com, vannapurve@google.com, ackerleytng@google.com, aik@amd.com, 
	ira.weiny@intel.com, yan.y.zhao@intel.com, pankaj.gupta@amd.com, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DB02B160009
X-Stat-Signature: ds5ocpwzrxesrzez8ew4tyw19x7j7wkp
X-HE-Tag: 1768332091-450623
X-HE-Meta: U2FsdGVkX192Mb33ueW2JOiXq+1x/DxQ7FG6Gblbg0TxPak3cPEk3QryDFi3qaajdtIaExlZSGgdnpfy/8DsS6qSiDJa+Xi4q0jUzsTifsKppmHPgmiYEr0tz+Nu7BeHGd8O0bh9VUhbkuUPeuCDfDQU5lMLJJQq5EErC1Hz/7uS7tWuCn352ez+b77EdyAQv5lZlq0De0gNB6nD22AIGTNGlEXQpT0gzp8sBxFsluFIHlEv3r+CtCGG2BoYFj6UN1gVVUIYI+XHkSm8LGDylBAZDi5If3dotyCazx8DZVoKellWvwnuJqNMzCWpOFyjofT73SxRgdj4++RPOKv1KtHkQr+vCzDosOtg42j0DZeHD9AP88BDQSbQWgjbQuq5KCHvLWjKUNySExU4c2MitRHj4iGaZyA1pD1hrR7K8DHeId8eBSBX+/cRWUgHAZie6lb2/Ipj+WX/iBUfrTpUTauuhMb2PTTsX4oxGX1O3I+DzuY/yI8jD5HoxhC2OBBSF4R3VkXZ1iCwqPBB4sXEOhoOjHhbL7+A3qxKbXAxOB6CdZj6W4MPsTIsy6Pv8IssM0Hj23F11WmTQQ5yjX4qUqRQEfw0C7HSDFU28OcCjLZw0WcYKagPrFJGNviEDfTTapb29b+X2wDxghTkWLqmAn8SYrdB9YfZtchHDbM5kVJ/j/yxJ+20sseyuzqRjkkFaNsTERA6UOp3fZGF3gPSp84f9ImOX+NZQ77KnQ30p9zfhAJXH347FD/YK7/br0x4CTp4gom6R7AdXLMbvDq1M/LEbgPJDCbxfeyJtvv/DQ8IvoWS3EtTjHwyQlT54Y2QlegSmMDG/qZt2x4EiskAHbfCVE2aOUQSWOXQS3NKSd3h/jbW7xTlbK4dN3uva1NfPkdtYm4Li4DjVPNf8zBMP+99SwKjyLy2S4rVtRtOUDIGQhWAluG8MpRIGpWdGFqyaSpEs4wFe/ZouGO0wKN
 N/EqeZ05
 xluA8Hg+DiXPdZv9FksahlvK2dQwvnbWVAjZQ2fwv2n8KuAruFNi+LwA57GWMgJyzvtcgu0qgP8Ze3nxrhqtkW3ukAbecqIB5DhzO0D8HGq0fxHO2ldJ2UO17lr8DakcTQu+KyS/33KZHtX87dk965ru0owFGQalEviUNshQTvtWJiurpwFi7p0aFmcxxrITVDrVvsOSzfGzpFo2RrnnlW12NVgJkXsU8+6u57pl/SI9lDXV+osiOrCS7prNTtlKj0q6ijoILHzehFypGHbFl/VPP6vNHO5a3ootWKjlQXpL2xr94NbJOgVUG27FwXOjtvuo9TA9UDwNU4ekm9y7JifXe8W0Kz60QK421yIwystPtWzYAnenaS8nu3FHzcpNUkinu83TYCXQtR8iRzv7YZVCl6qQKbosz0NsUd6oJ38qV8j6a3kb9MpCQGnNZ3Q9AcQ0UQbplnHWJtDwVbIsk1TYBWEYpOHyC5/QKKAH0msVQfF3ZmSCm/a7W6BY7XxKM6S6yty1ANiwpTBrszsEY9npg2WEi82Z2GRYRaxkdrZSN8LTETXxnn2HgjNa0NcQ3FKwOuX5SUtXEkXomkXkK+eiuvVxyf4RQMT2V3W82INhu5uTQ6D6r+add9HjlUSanRGVfBg9Sgt1Q12U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026, Michael Roth wrote:
> @@ -842,47 +881,38 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  	if (!file)
>  		return -EFAULT;
>  
> -	filemap_invalidate_lock(file->f_mapping);
> -
>  	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
>  	for (i = 0; i < npages; i++) {
> -		struct folio *folio;
> -		gfn_t gfn = start_gfn + i;
> -		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> -		kvm_pfn_t pfn;
> +		struct page *src_page = NULL;
> +		void __user *p;
>  
>  		if (signal_pending(current)) {
>  			ret = -EINTR;
>  			break;
>  		}
>  
> -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
> -		if (IS_ERR(folio)) {
> -			ret = PTR_ERR(folio);
> -			break;
> -		}
> +		p = src ? src + i * PAGE_SIZE : NULL;
>  
> -		folio_unlock(folio);
> +		if (p) {

Computing 'p' when src==NULL is unnecessary and makes it hard to see that gup()
is done if and only if src!=NULL.

Anyone object to this fixup?

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 18ae59b92257..66afab8f08a3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -884,17 +884,16 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
        npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
        for (i = 0; i < npages; i++) {
                struct page *src_page = NULL;
-               void __user *p;
 
                if (signal_pending(current)) {
                        ret = -EINTR;
                        break;
                }
 
-               p = src ? src + i * PAGE_SIZE : NULL;
+               if (src) {
+                       unsigned long uaddr = (unsigned long)src + i * PAGE_SIZE;
 
-               if (p) {
-                       ret = get_user_pages_fast((unsigned long)p, 1, 0, &src_page);
+                       ret = get_user_pages_fast(uaddr, 1, 0, &src_page);
                        if (ret < 0)
                                break;
                        if (ret != 1) {

To end up with:

		struct page *src_page = NULL;

		if (signal_pending(current)) {
			ret = -EINTR;
			break;
		}

		if (src) {
			unsigned long uaddr = (unsigned long)src + i * PAGE_SIZE;

			ret = get_user_pages_fast(uaddr, 1, 0, &src_page);
			if (ret < 0)
				break;
			if (ret != 1) {
				ret = -ENOMEM;
				break;
			}
		}

		...


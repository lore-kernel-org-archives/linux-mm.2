Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A3DC44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B606B0170; Mon, 13 Jul 2026 13:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2ED6B0171; Mon, 13 Jul 2026 13:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920346B0172; Mon, 13 Jul 2026 13:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51ADE6B0170
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:01:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D59971A0122
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:01:29 +0000 (UTC)
X-FDA: 84984369498.25.038D23C
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C15F1C0028
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:01:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JO9XZoal;
	spf=pass (imf18.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783962087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9LV+16tD32KS6yXCzCBkB0u2lL8SNr6pDg+a+HPC20=;
	b=FzahPht3SXVrFsAscZIc0kz/hiTX2zLHEccEHrgmZLeo3oTjeHX8sNT4THunVUBgM0cAYe
	sPebLa8StWkc+9jbDfhqK92xXb56qFFd3ZOigd0Ezr0m/nWqRcV+cXXsdKysO4h2yvbSU3
	eSiWeomDY0wOFC37aoTp9ygZqWCcCqo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JO9XZoal;
	spf=pass (imf18.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783962087;
	b=izbTAOzFiTRHDh4iC4eA7KYOTiMljlSF2WaOvpvaWqtRakOgEHX2GWNLLMhp8QuExrVQ35
	pKRHCXI2iHYuO6ZuvElzrqJ5tNlGxe3thGWtFNaCJrHXILsy+8QYyXEGi9hcKVnUyTAnSh
	2/oUs398jlCIXi6X3CDOPIXkE6ZAhwg=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cc61541f8cso1114655ad.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783962086; x=1784566886; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R9LV+16tD32KS6yXCzCBkB0u2lL8SNr6pDg+a+HPC20=;
        b=JO9XZoalZCgXujz+Btc0AC6kye9hcw846lBxRp8iJzvvB7BJx7Vyne196ZqIWXiwWJ
         htKIVQ/ITkXNFI1JbZ9+4ugJONse0dVKnIx+G8tQiV2N3qvlOhFT/LneTYFyHjBFr+WZ
         u4mpHD9sm9M+PP/n7xpaWv4aLMqBzdVYYNifw+aAz/Ng6fIlXf+/XH4pAPK6WhOM72DI
         eIZ+KXY780jv/qCHh9yrHrt6vjhYclh2Qu4qpkBiRCnohzSsDp6/9QYQBAicZzvawm5r
         vttJ1jEbmrtHRy4aJvwjoJ9evrKOWE6VjU0LrEC5bHYa1fbLT34TSX30LvsRAtvebVla
         9YkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783962086; x=1784566886;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R9LV+16tD32KS6yXCzCBkB0u2lL8SNr6pDg+a+HPC20=;
        b=pi3zHyf1oo9OidxfWaspjJl9sKL8dpTUb+o2mAL0RiPfD7jvmFmhqH6fEuc3elbaxS
         +ssBkiVX8bLad2yk9Q0XDROiWG2gaZP6e9Mjo/UT2PvTr3I2AoR069cBbsHnpHpcUnMm
         mlfs0EZ4cp7g5u8fJ2gvEgbGwrT6T2W5w422Ux6E43MCaevreaU8E7s2JxSbf9xzjuxJ
         bOyDV3/MmERdUUlrqGa+P8l/+jA1cj9yS3mSBWneQ8gkTcHVjYTUVJTKt7od5XzYbGn6
         jko1XzdODTL+Oyk2Bl9B5arakNuxl1y/C66ds2NKfy6iF8iFHkuRc+hpnKNWbSFcUkD4
         ULPA==
X-Forwarded-Encrypted: i=1; AHgh+Rp0/ODC4sOr1hWxD7IKtOUIAc4OEXbkaMg8Oe3jp1oZI8j2ZOsSaTgzWXKIB+VR8b+mqa/nFtr0og==@kvack.org
X-Gm-Message-State: AOJu0YwX7I0fgsxkipQsvNIgI7nSNw88pZuuzMTPV0HlIgJhjC9bfqk/
	2+205m8H1ne2XxfAU0v7CVrEQO4gp4Q+coo+xR5gxqgbl4/Mu0G7Iu1E
X-Gm-Gg: AfdE7cnUUS79pIUi4ypizw88m2M2OXA4Wp5UjMhYRLwtgdotpXCph9GC5WZuYxgdohk
	1Cu8+QDALJGxCK5rGG0U+mGcBfgCfU6Z82crvem+LC7T+2TFGoEAKXGg/Wh+d7CL228GDLmdjZF
	u7UVIPL3YW4/aJfbhD3lP2qLRwUTJcj4NjeimefQrM5WT749arZa36lM+yogGAQvlw4yIdSpeMS
	E4cKlbWgS5mBb6rmp2v+HXTNDwyLkBb0/Zfb17aQq69zlp0BRYUjzpDoI3vS1GeD1tqUsOABci/
	Az4QEL7jKJtM5pmdHsX6Fg+sAy9ldBu2B3rpQZw/0gTYdBUYqVCi1Zh7VLzgAvW2KUOc7QKb0YB
	M3PNExCEioXbEMIAPljDwknqjsogVQIvoqeoAdYJjjWU2oHoFFMokKRJH900mfd32edq+Jm9vJL
	y+Ipeu7eBub+4ogPzZ2qK2MlieILT1Vt7ZTYV7Pp/6vw4fgFRn2H6MoH0=
X-Received: by 2002:a17:902:e88a:b0:2ca:de3:15d7 with SMTP id d9443c01a7336-2ce8292bad0mr123460335ad.16.1783962085860;
        Mon, 13 Jul 2026 10:01:25 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d3d451sm102224465ad.65.2026.07.13.10.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 10:01:22 -0700 (PDT)
Date: Mon, 13 Jul 2026 10:01:20 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, jgg@ziepe.ca,
	kees@kernel.org, kys@microsoft.com, leon@kernel.org,
	liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
	longli@microsoft.com, lyude@redhat.com,
	maarten.lankhorst@linux.intel.com, mamin506@gmail.com,
	mhocko@suse.com, mripard@kernel.org, nouveau@lists.freedesktop.org,
	ogabbay@kernel.org, oleg@redhat.com, rppt@kernel.org,
	shuah@kernel.org, simona@ffwll.ch, skhan@linuxfoundation.org,
	surenb@google.com, tzimmermann@suse.de, vbabka@kernel.org,
	wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 8/8] drm/gpusvm: Use
 hmm_range_fault_unlocked_timeout() for range faults
Message-ID: <alUZ4NQptiD9fRfz@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <178371883977.900500.2198446134676328631.stgit@skinsburskii>
 <alUSq0o7CC2Pnr+H@gsse-cloud1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alUSq0o7CC2Pnr+H@gsse-cloud1.jf.intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C15F1C0028
X-Stat-Signature: 1m3rpsjycpdabfmexfaithtx73rae19s
X-HE-Tag: 1783962087-994888
X-HE-Meta: U2FsdGVkX1/2NiK9RIIYUglsWumFF/HR9z2GZeVylN+hWbJczdtp90IMP355JUR5rlqvMaVKj1/bcAelpjO4IQCcrQhgdxtlk1by0KNKO1e+hjZ6xBbGiSwqGm1sgx5CU3Oyydt4IeqlYp+FdcQ/pcQcTGqZSEyOMGKrWs5QwLMw+JXVyVyJbhqI8xooUI4xB0xCbug9AvDYxSdWz1bFlnqeu2nDRpAoTUXB3SZis0TobVUTYlv5qBDXVl0xH9CFl3PazWJjxAllZ+dKIu99/554mQFcO78vJec6H8Z6AnpOyFZS4Ouzp9pwDFUu4LGbNcm5/4uRNlHw3RTy97SOlQRsZD06sZVyoqOTTCr7XHtv7E7RnVtNgUBj2vbbhrNLHrV7SIEpPylvZmYbqeDXQ3Rmb9gatE6ARiRwgAr95Mv7qpfpr23wwuC588g0KDmg+k66vCx+zNydd5a0c8WAhqIKhuYD4egf9/vN1TRqIH308P18ZEQUl/rYLCY8kd2rHkwiAPBl0qKGHgHwc9BXezF7SRNbxMOUYbshQQujNWNBc/RIj9Oh7Yp+VOx7hr34MYxdc9wppzG8d1xSZOHjuE2derZuD8z3hgt5XTCPM6PJPySA1zG4q7qsxFYDc0fbZOjTx7+dXXFBcY/c3F1MV34nAxLAKhmBkI/dlDjVqXO3yJwhZqZcsALgUh51cPUeoR2DP0fVHcoheiP/Ro66xsHLir6//3GpY6bETFsSGA1grXXZIjm3tUCNY1nIlUUzT+uv3FnPWOYy+s5djyVOQzDFLWyi4qggbdb+zi8cFn10+CCbOQfJJIjO1AltZiKMZl6qwDbbNcwKY8fgGIKnOLtTxRv5jwRFXoRTlshzzGVl+UHGHlV9591B6anfMNQfuzZ3deacdWqhSVTyR+C3v43cCdj8lRFjOp0qclZdV/TnY5MTJ1q7v2GJOGJA4w9cvB3AFKoLOyjUr1aiEEg
 CukeFYEw
 sAbfHtBoW5dxTp3tGv+rkhFYWtqC2ZCe8kOi83/v+dZkGvS07xeOjejuL07+L+X84b7X1g8GTLL1Q1nN4lz0kowF3oQdwvsuv0ysWbOI9BWiyX/0a6SN38Ki475iMC+Vg4PcQnWRsMb9O+fHFb0m2y7uujbDlIaVnEVHiYMsstVn9hYkmZW51Qe/Eocl6EKSPG70+sq5EcH8kdNrPmapCbwtVJWOARk88NpHZtgA624ho0L7js/L8ckDfNC0+Kqymjt3n03Sd6DrB+KYW9hkGTVJ9ogxLipjmhRF4KRjof/+z2XYc/tUNTuxJ1lxrn166l/+Afnq57iHHeYHa/erCqEYK8QdRxMRm+9ZVeMcO4umPO9s5SeULwEziEdEYyazOQ/PaELy9Omu6qbhpKZAPOn8ZvkQSYTt1gL7ce5qXxeDAJHRbV13mQ7nAPNhvj2a+tiExqPHsD599isJEYiOeuQxRjazlEc6M62vBItRK/w4B9IgtxAy2fJo9OAZU4Ismt5inHh3zuOc8d7rgJxTfqRzBvkZHA6I4kJJKR54UfEsLKniC0Z0Ca0EYfsXOHcU62KpVAX0uD/9PG6tiTaURMktHL+SAfZbJmFZj0wgODhAkiyYaa3TxhAM2CJsl43qQupyV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 09:30:35AM -0700, Matthew Brost wrote:
> On Fri, Jul 10, 2026 at 02:27:19PM -0700, Stanislav Kinsburskii wrote:
> 
> Please send series like this to intel-xe@lists.freedesktop.org list too
> as this will trigger our CI which expercises the change paths changed in
> this series.
> 
> > Several GPU SVM paths take mmap_read_lock() only to call hmm_range_fault(),
> > then retry -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires. Those paths use
> > MMU interval notifiers whose mm matches the mm that was locked for the HMM
> > fault.
> > 
> > Use hmm_range_fault_unlocked_timeout() for those faults and pass the
> > remaining retry budget to HMM. The helper owns mmap_lock acquisition and
> > refreshes range->notifier_seq internally for each retry, while GPU SVM
> > keeps its existing driver-lock validation with mmu_interval_read_retry()
> > after a successful fault.
> > 
> > Leave drm_gpusvm_check_pages() on hmm_range_fault() because that path is
> > called with the mmap lock already held by its caller.
> > 
> > Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/gpu/drm/drm_gpusvm.c |   52 ++++++------------------------------------
> >  1 file changed, 7 insertions(+), 45 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
> > index 958cb605aedd..6b7a6eaebcd9 100644
> > --- a/drivers/gpu/drm/drm_gpusvm.c
> > +++ b/drivers/gpu/drm/drm_gpusvm.c
> > @@ -788,22 +788,8 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
> >  	hmm_range.hmm_pfns = pfns;
> >  
> >  retry:
> > -	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
> > -	mmap_read_lock(range->gpusvm->mm);
> > -
> > -	while (true) {
> > -		err = hmm_range_fault(&hmm_range);
> > -		if (err == -EBUSY) {
> > -			if (time_after(jiffies, timeout))
> > -				break;
> > -
> > -			hmm_range.notifier_seq =
> > -				mmu_interval_read_begin(notifier);
> > -			continue;
> > -		}
> > -		break;
> > -	}
> > -	mmap_read_unlock(range->gpusvm->mm);
> > +	err = hmm_range_fault_unlocked_timeout(&hmm_range,
> > +					       max(timeout - jiffies, 1L));
> >  	if (err)
> >  		goto err_free;
> >  
> > @@ -1439,21 +1425,8 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
> >  	}
> >  
> >  	hmm_range.hmm_pfns = pfns;
> > -	while (true) {
> > -		mmap_read_lock(mm);
> > -		err = hmm_range_fault(&hmm_range);
> > -		mmap_read_unlock(mm);
> > -
> > -		if (err == -EBUSY) {
> > -			if (time_after(jiffies, timeout))
> > -				break;
> > -
> > -			hmm_range.notifier_seq =
> > -				mmu_interval_read_begin(notifier);
> > -			continue;
> > -		}
> > -		break;
> > -	}
> > +	err = hmm_range_fault_unlocked_timeout(&hmm_range,
> > +				max_t(long, timeout - jiffies, 1));
> 
> Unaligned indentation.
> 
> So I'd write this like this to avoid weird wraps:
> 
> ctimeout = max_t(long, timeout - jiffies, 1));
> err = hmm_range_fault_unlocked_timeout(&hmm_range, ctimeout);
> 
> >  	mmput(mm);
> >  	if (err)
> >  		goto err_free;
> > @@ -1736,24 +1709,13 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
> >  		return -ENOMEM;
> >  
> >  	hmm_range.hmm_pfns = pfns;
> > -	while (!time_after(jiffies, timeout)) {
> > -		hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
> > -		if (time_after(jiffies, timeout)) {
> > -			err = -ETIME;
> > -			break;
> > -		}
> > -
> > -		mmap_read_lock(mm);
> > -		err = hmm_range_fault(&hmm_range);
> > -		mmap_read_unlock(mm);
> > -		if (err != -EBUSY)
> > -			break;
> > -	}
> > +	err = hmm_range_fault_unlocked_timeout(&hmm_range,
> > +				max_t(long, timeout - jiffies, 1));
> >  
> 
> Same here.
> 
> Nits, aside LGTM.
> 

Will change as requested and send to intel-xe@lists.freedesktop.org next time.

Thanks,
Stanislav

> Matt
> 
> >  	kvfree(pfns);
> >  	mmput(mm);
> >  
> > -	return err;
> > +	return err == -EBUSY ? -ETIME : err;
> >  }
> >  EXPORT_SYMBOL_GPL(drm_gpusvm_range_evict);
> >  
> > 
> > 


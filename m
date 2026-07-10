Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8708AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8DEA6B00AB; Thu,  9 Jul 2026 20:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E666A6B00AD; Thu,  9 Jul 2026 20:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D56E56B00AE; Thu,  9 Jul 2026 20:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A75E66B00AB
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:45:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 373761A02B1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:45:47 +0000 (UTC)
X-FDA: 84971024334.07.7217C90
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 52974140008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:45:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JJDN0WnF;
	spf=pass (imf26.hostedemail.com: domain of linkl@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783644345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NDxZOCfeqZWYG26A8bUT8OjQGBJjjUiBg2MLvfAqRA=;
	b=ef7NUKuZxdV2sV7bEj1qVFMTb0g+HseChza7twkqHLYIpXzItGAN3G/GqF+cChN6RxVhdP
	Yhbg0lIF4ml9mMFBDJuDLNENP04g+1YAxt0HPW+6gXb501oZUdYisxcBr9FVNma/MPrYcd
	CLb0uoqPE6ArZtBf7TEkw+xfPSjmPiw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783644345;
	b=EkwCGcRUtPhP3QTsY8SdaXb4/37y4HG+f2O3ev6WpRdMuntDrXrEykGXVAaTis40ZYrmGU
	U5fi9ls25AQF/JOzKMgoluPInqV6PpW9DoOOp+jjBss/eOjC6w4uxhYF4zWcxmtI6KlU3f
	M9lXLSp+4fwA44LYirmAoOD172lQe38=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JJDN0WnF;
	spf=pass (imf26.hostedemail.com: domain of linkl@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c15a5b265so117421cf.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 17:45:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783644344; cv=none;
        d=google.com; s=arc-20260327;
        b=TgSyf4L3dZHE/mLpt4CN7vQnhZQwQ3XQE2+pd/NvEHF/ofPjEQDrMObggQk649MrGK
         sLgz41p7Yk8zxCZkt17WZz8m2MdvyMgAEy9kgrVYCsb0M2u/cAyR5ckWxfV3uCedFK4z
         H40Zp6YNesoz/bKbe6k+vr8TNzvRUS8H2dG9icxBT8u64zetJZtg4plGcKQ+jb1/3h/h
         v6JZyWDJeCSivMttiUMrzxUobCmC/TjBsTA4TdC+JU+6JClDFyCpJjpQG3T2LdorEQlk
         vMQWTSQ/OrndByvEHtax5MNPhU84V7ugcaLe4M3WVYDb34ip7406IJ9c1tf5obHklWsE
         1SPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4NDxZOCfeqZWYG26A8bUT8OjQGBJjjUiBg2MLvfAqRA=;
        fh=QsZFO3yyfAfgp5r/fehvKLhheA+Nk/yqT4OANAS483s=;
        b=ns9eyS3bI5W2oMkSZNkYe5/oUfPxmQ+fsfP/KtiiaQXdfF6Zv92IIKqVDGQAULW5fe
         yJMhDDFwMDm+Y+eA9BajccNlw3pPQwFl2XaAY97oRn9SG1VWksBOUOu5F5M6SIFnT+bE
         gUxsdDO//sOF9VC+wTlhvEjALY55U1o0062iQoYf7Hp3vCV81ikA5uywJX90LFLebn/W
         vk5rhyMcgzelsc1K5yfc6LH2iDAHzqGYiwRZs3vAujGPFkFLaTKLqncsTRSG5gd0/ONa
         mBTZ0OU9/SaCXKFbaX9xhGUWhDG7/SSZUzrCKKYK3JmgK7CbdNKZhetYlVXAE13RCdoY
         MbOA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783644344; x=1784249144; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4NDxZOCfeqZWYG26A8bUT8OjQGBJjjUiBg2MLvfAqRA=;
        b=JJDN0WnF9yRmDMEoalDiijvNi2ps7ApVFQl8PYR+hxk6TYJjitujteYypegRe1xakV
         wluNU7KsDYZjMID/DsLFfgXwuxylAZWtCoZb6nd5E4/xfylTzRrPznIMEnL8Fmue78Vz
         sD8kw+1Tm94S04Mr1/C26L5iHpK4RQHGt5q8a+yIzgqk5Jl+K1p0gFh3lXQtcWo5i3sW
         YEnMf90uQyEIcYosPpzpC7u2zPrQJJelaDTenzl2qOm/aRdxtNrLFj9GP4GCZSJeXXxf
         wbHug/QOS4RXTU6kqm5XZhxXeNlgpL63HQbyjFPMRz30mDxADtjw1bmH7oCcfKrfE+I4
         P2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783644344; x=1784249144;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4NDxZOCfeqZWYG26A8bUT8OjQGBJjjUiBg2MLvfAqRA=;
        b=F8o5wGoAIkBL64PBhKDmNvtBBTPuYbynWPoKq8ZrvIus/G/oluSYoAYgYC5fs/5uwk
         Q7BuXuX9ch67bm8wLjTF5mGBFwZtCPFWoNSoZuNmOSqQEwmcO/Pm3ulz8SO+wWvHBe5U
         VJIYlTeUdgXv8N/m2XuJSs7B3FLBmoqyxXxd5PQnlA5ZrAC8/SvUMW7hSwfKucrN9aPT
         X8pDifpk1WliHMzeUn1rEkaF8w3n5nz8wavlhnHb0YIY5k+PjaraDGSI3u+5LjglQXSc
         YmIPbVaUzZIBZiZdsdpVTiYmFrwMJ07pIdf58uQ+obSALvNKv6FaLD/FZoyVlH/B/v5g
         mx2Q==
X-Forwarded-Encrypted: i=1; AHgh+RqfCFNf1eC6+KLwrPsjSQB7bbdSX3ycBDDLDzve6xIk0Hs74oovl2o6d4BJUKphfuyawwjWVPjLEg==@kvack.org
X-Gm-Message-State: AOJu0Yzuq7dgFcaIFRpiOZ9Ng/pU4GMbvr7+OIkFcaqvc11anpQ6TEMU
	yH/Mi3dlkJWWtbil5QYRkghv42mI4VW2hGVIrDHTuYX4wdLNsg4XXZJyU96XuT+SlBiDbs6/CiV
	JMnO0nou9aY6A1AyzGaVeK9WOgmpZ5NL1iATQ8+vD
X-Gm-Gg: AfdE7cmmOFkqCAi2iFgoPxUtc689JYQQ2DOV1GcnERIafrTmNla6HosGCz6v/j+ujyW
	mi/O4VIpB9RB86r6fx9v5TOF3IgTAoxwF1cHIXo62/OwEQIrtcbBNhUvX2qWSSuIFN23eLb1CkU
	SGJ3nOAydf6FbUx3C6PoqJnGqL0EREzeSf1W7e5YvcaYhTBgKmQhy1cZ8/vUrNKTDgrOm3qVF8F
	QGQs+nziI05Br0HwNmqYfwGMTFqWDWM4qyz1H3HgS/HFZwJiv/RJImnCuyluq1sHMegXv8SKUz1
	hNNsqKymHGDeiVkjnTg3nQ9Eyg==
X-Received: by 2002:a05:622a:1f09:b0:516:d570:82c0 with SMTP id
 d75a77b69052e-51cac54df32mr2758731cf.15.1783644343839; Thu, 09 Jul 2026
 17:45:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260709224330.946683-1-linkl@google.com> <20260709161253.6b5e9ba349f70a3ebfb8180f@linux-foundation.org>
In-Reply-To: <20260709161253.6b5e9ba349f70a3ebfb8180f@linux-foundation.org>
From: Link Lin <linkl@google.com>
Date: Thu, 9 Jul 2026 17:45:32 -0700
X-Gm-Features: AUfX_mzRlthWGS4tvguyuxlqGde2yyyYF501igG6ylQK6FfQ-MElEO9rT5w6uEI
Message-ID: <CALUx4KQ=bYTpDoDAZ+iVb7Ehaa0LmyPDsEWk3xFFmTVYKrpAUA@mail.gmail.com>
Subject: Re: [RFC] virtio_balloon: fix Use-After-Free in page reporting during
 PM freeze
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, "Michael S . Tsirkin" <mst@redhat.com>, 
	David Hildenbrand <david@kernel.org>, virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 52974140008
X-Stat-Signature: 5bgwed4m8koruscm87mgwc9tczihjhmz
X-HE-Tag: 1783644345-499432
X-HE-Meta: U2FsdGVkX18r7i9KqSyVKMOTqwddiSUVzHIVF4Woo7UFUyHUJ5G8gmD2kaGfNvtjduI4x2dsWYai9K/LeIO3kIefobqtF3iF6mzy9yn5TOEevb+cAJPNuz+PabRnSUAND9T9CKIkRwKxBLzoXDDrtUid/YEivX4cIMLknqNqlXXseU2qSeP+ctqesoHFs0OW9qxDliTBXZTdBb3l9XGxiL3WGz4jZ6iWxbk90bmGH6RLcSSrOc6/VQe8RPuCALPmk1CZ4HsUN2s8BMRJSZ54Fjt3n0TF8msocw1jDLb3lVfS60KU0hWqeKyHkZ7mdQrL8gJZs7PCJLeSmQ2Lb0nnK/ialLFPJVu+QsDYweTq0VX/rSR+by7pmZMqT6+ZwFN3oGicrw/p5t9GTpYEDhWZxi0g/eToRHcb3ZaZs4FTC9xBBTwteyoVMCl49V2qKOcoViJTTla9IitpUe1miXN65mo6I6PZQ+bw5yPpRM3CTM41PEE7MZlb5hqiMJWVXuzIwSyJI+JSCRDvylC3wtnpdmbGACzeuLOkviVV6VtlUpf2rWykcTcPu6o9FNy+LQSPk5nN8ShTXIA5fBx5UgN4xn1kcfbIw79qQlioWRsqkxgWYct6LBilStfaDxPB8sZe7hiDiX+blA4469ppq/sRYMhagdSGqkDbMye6PM5rXg2TJo5UqLmoybJAb8FHfAUhst8DuHWdQMvmX04ob1GnRFaazCxtTnxr9K0LzomUJY/hKPl49H0cXSeYqaSME6mCXKZP80yUdzVQvPw16ti7L1TvWEoI0mqNRvwHw3sLxn7jJX49uSb4FHTqtcqZmrGk8PLHyRonbEGw9sfbq0S6HGvhpAV12kcB+1DE07b9mtpvrvnrV2yBIVqkwKIR5XOprKcNiUG6zc1dFBXWM7Nmm4uIORFxzxRYLw+VK1CBv6BWdMAVjZBmrenynPCQfiAvCOSk2iI3p4CXYQlqopY
 dcnJCM9A
 kGIuVjaoOFthT5SsGFQqkwzLnh4++QpesRku2PNS0zNfV0SWhMFfDrp2CwdXWcD8Z9Kc7S74OjjD9DiGYyfZI9FGbu5EBy90Jneue5HEwXAMKi+8QfVuQEExRJPP9I1hz6239Act4vPgPUCGry3y/p/G22oDJcneE9ercnhyBoa3boEzTEcFwAh4pvPrBZhHmzTc/ZPvkW0Io9vzi1WoZ+/tYncbagiZDvjPkDjXWvyrFYHcWJ8vgJ8oIoqMKEtRd4nozGTuAhTD6AarIPdzvRaPLvSjaT1n00NxFPyfyk5XDf+DkX2B6PEWt7qfp+E3yrpUEwwg3l78Li0oT8/U1zl2BbqtXw5uELy1Vq+xDMHhLr1n5xmMf+vN3nNFiaeYsZnpdRPKDyOAOZLbp1n96jbJBQudOPHxv1IkHhLWLBju1QpQ8PFhdn8pQjPveP8i0t2y+wPgu/hUuTM+lDbsWpgZQLwdsNHr5LMNKtP7CzziQrlrb4Wxvv+EqPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Jul 2026 at 16:12, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu,  9 Jul 2026 22:43:30 +0000 Link Lin <linkl@google.com> wrote:
>
> > Fix this by:
> > 1. Unregistering page reporting in virtballoon_freeze() prior to calling
> >    remove_common(). This clears the RCU pr_dev_info pointer and flushes/
> >    cancels prdev->work on system_wq via cancel_delayed_work_sync().
> > 2. Re-registering page reporting in virtballoon_restore() after the
> >    virtqueues are re-initialized and virtio_device_ready() has been called.
> > 3. Unwinding virtqueue initialization via remove_common() in
> >    virtballoon_restore() if page_reporting_register() fails.
>
> AI review thinks the patch didn't do the above:
>         https://sashiko.dev/#/patchset/20260709224330.946683-1-linkl@google.com

The AI reviewer might not have parsed the entirety of the fix I proposed.
The patch submitted definitely includes the changes to virtballoon_restore()
for steps 2 and 3 (re-registering page reporting and unwinding init_vqs
on failure). It seems the AI failed to parse the diff correctly. See:

+       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
+               ret = page_reporting_register(&vb->pr_dev_info);
+               if (ret)
+                       goto out_remove_vqs;
+       }
+
        if (towards_target(vb))
                virtballoon_changed(vdev);
        update_balloon_size(vb);
        return 0;
+
+out_remove_vqs:
+       remove_common(vb);
+       return ret;
 }

> It also might have found a couple of pre-existing bugs in there.

Indeed. Regarding the first pre-existing bug found by the AI (leaving the
OOM notifier registered during suspend, leading to a UAF if memory pressure
spikes during S4 hibernation):

I actually addressed this in the commit message:

  "(Note: The OOM Notifier and Shrinker/Free Page Hinting features suffer
  from an identical lifecycle flaw and are also vulnerable to UAFs during
  S4 hibernation when memory pressure spikes. This patch focuses on Free
  Page Reporting, which runs periodically, to ensure clean backports to
  stable kernels)."

Regarding the second pre-existing bug the AI flagged (leaving uncancelled
works on system_freezable_wq if virtballoon_restore fails on the cold path):
the AI is correct that this asynchronous work cancellation failure exists.

Since these are separate, pre-existing lifecycle bugs, would you prefer I
roll fixes for the OOM notifier, shrinker/free page hinting, and work
cancellations into a v2 of this patch, or submit them as a separate patch
series to keep the stable backports clean?

Thanks,
Link


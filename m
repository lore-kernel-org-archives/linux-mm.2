Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D96ACD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 21:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509B76B0088; Fri,  5 Jun 2026 17:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E17D6B008A; Fri,  5 Jun 2026 17:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F76C6B008C; Fri,  5 Jun 2026 17:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CF046B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:54:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E0A08CE10
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:54:08 +0000 (UTC)
X-FDA: 84847212576.27.237A266
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 97EA7C0013
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:54:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iI4wKL2O;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780696446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GoJ+Vwme80sUgV4v1KvmROpzHYouNqOpe95veiDZSmc=;
	b=Y7HlBtS/AzCvMisZtj+5leBMFBEAXRYBVjLK48BawCzvIR1prglcs00yKUKAtyXcQ/FW61
	Bz/PmFBPpXhCLCxIo8nLlucPyWLVmtqIP2kiOkTcSUqeSxNKkQ4jyxEaDyqz87hZoBgGAd
	9EXRNvnNVaDhOAQnit014iB3yEGg+/A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iI4wKL2O;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780696446;
	b=xrOb730qCv2VtwxhxzMOHlfmFinMbeehAEiwcoKfN5Zc3eCzDvZ4/6i00CIv2utMo/u0Se
	H3rTMCTsd2eERllCJCRTZzinyDTfq3t2e0LpvYA+i9m4Vjf1v9H1EaRYciDLJBBAJ3O3A4
	DG3/l2GrxB2swoeloNT8oc/0MM57iJM=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8ccf6a63a45so28818396d6.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 14:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780696445; x=1781301245; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GoJ+Vwme80sUgV4v1KvmROpzHYouNqOpe95veiDZSmc=;
        b=iI4wKL2OxPJgeq5FKoDjaE93A5k2FvKP/Z/OtN/NverJz9LgR45AS9T2UkpIXZQDar
         oGTAl0hMy89xEjkxIp8V8HQem9msNDTfnfoyvuupvwugs2Bh4AXt7rW9HmRmcOlex3pm
         qx8oLs3rAMIyZTwOgRXyikiJwOjC6UqcobKPCO42n2a9f9Q/5JryKdPLj9UaC2FXe1Ei
         umFsDIWDv9rOuqTIZ6XnFareO9dIOvni5fd98SLwskZaNaBW4j/iKdHtU/SGeBTr+uVN
         cKRwfkWGaEaCJ9OFjiE01kkMWzyz4gj+rrFp1VDPrJSg+6ERxg+WuX4HcoeERKdmZVbt
         XofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780696445; x=1781301245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GoJ+Vwme80sUgV4v1KvmROpzHYouNqOpe95veiDZSmc=;
        b=lc0yYqNIgkCbM7VoRMGbL0A1ZbTeqM4ZW6rK0Q2oJbyxfjJYiDdNmys4Fsfocmsds8
         2MMNoGo7SDtLCNLYiUazxuFGGnWB2j9QsAKlRnNd3noYkbKxqjH2dTCOpaxSKg8bnbhN
         U5K874HpbZnIgFvdZNTKlsLnaad9EU5aKT3pI+BlSDiqkC7z0T4rZL9bQIAvsmMQiC7l
         uZQfMSygGVNeZhmxt7uavH0xt9P1rD4dk+Su+I7T3rKMR4OgrFWaBc48/Bl0opX1Sy4Y
         1s6dGvEUv6jmfN/bwweyfGFkpxg6lspDjXU4rO6dZZgxOWIdtxF3DW3/kBbUZmdwdONI
         69cw==
X-Gm-Message-State: AOJu0YxcBL1kwKD4opSqYAoUJuUot9f+Ff6Zs2IZFqZjCXFv+7DCrkkA
	qAldXffziTzvHLDFRt7pGB2zGigKKmvOMBPUuyeXZgFUSnwqwEdLAXLq5dYAgQOp4po=
X-Gm-Gg: Acq92OEBY8P5vgb6vhoga4aY/RZmpH4ADExiu7tzzOFANqAPhEuDHirPWakooxlrUnY
	Jp0mGroycyuzmlLrJBQJ9w+wHqXGn9IWxncpkULkUNKRErZNhL75ryZ79EwiBPkVlxIC1Ip4ANV
	8yHG2lr0Ag7xcIUg66UGK9ZdrWshtEh7lasXirPi/3KVmbI8cZCjNFKIhS8iLFqQnZhAtf+Shcm
	NdR4kltRt1xIIM7In/jDh62f3YEWNODSxDVa/b1UnA5+62UM4uTD2IRB5N58Y5rp9rgFyYDE08Q
	aRLFJdunkAMRj4GYEDnQpS/AqiBx4fhIteLf/wXw6KJILToWhy48o1j6xfIqeaaDwACqM+QwXDo
	C3w3Nua5fQ8IDOlHOli/UhRIgosOaTKQ1aVUJ9f8IjiSmHeR+knqK+ql/9pzxPBplY7upgbeVgw
	tOzx8oa4RNyIwb4Vq1dkr57wRM8isoXMTtlGxSVePG0ob6auUaJPds98bOH9u5w1VRekeb+HOAa
	COoCXBXL3vGJBf4fw==
X-Received: by 2002:a0c:e98f:0:b0:8ca:2413:607a with SMTP id 6a1803df08f44-8cee5fe51ecmr66740956d6.5.1780696445597;
        Fri, 05 Jun 2026 14:54:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd0535b0sm93658406d6.28.2026.06.05.14.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:54:05 -0700 (PDT)
Date: Fri, 5 Jun 2026 22:54:03 +0100
From: Gregory Price <gourry@gourry.net>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org, david@kernel.org
Subject: Re: [PATCH v4 6/9] dax: plumb hotplug online_type through dax
Message-ID: <aiNFezMarbvIZNa0@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-7-gourry@gourry.net>
 <20260605213143.A18F01F00893@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605213143.A18F01F00893@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 97EA7C0013
X-Stat-Signature: 9ndfsawq1cmcyz4jaemdu63jspqqrgxc
X-HE-Tag: 1780696446-740994
X-HE-Meta: U2FsdGVkX1/1OYcKRNk5KgPawZ7Im6bh0XBMLrp7oWyImvwR3dWQRshYJoeAZyoMSOz+rmo1pMR+Gq0x7NNl+4+BblAMg1xktLbwRRb6fPDCSKa9/cenmtm97klbve7gC4PkGB4VtCy2bwMIafpVAXjc9N3eGIva7uAiVgfkzxvsZyKrVRBeQ7U9d3riozfNL446b7K09orgkktAbGUPjhKOTmyeRHyvKtpyvDGiQkgx4K9p/i8KS3xVVGJWTOJj7JmyqMJuxLGPhIVokWezwlbsQ8qCfn1ag/b7pcgYUatKyzm/3e62heYF/lBuTe3RtvRe0TBaol42AJwDMnvNqWJM+sckgd3xtnHkJel8Un/j0nP/bYlBFWErEJ6ZrK2aQcX4lMOgmPpchVourp8aWdPVkzCHm7eqpahqmpBzpV52nfBVEiNAbaL/xCAJ/wQq0ySLVkc2xAcrqpa7gIH4WFr7Au4y/rN1UND3XTe5uLnr6TZE/CVJB8m465Upa7H1Y3WZpB9ZTEABY9mvFehYS9R6nBWWQ0h5iuoxfagsoWl2tZsCDzwpXX5N7lb3u98NlaG3sPKawXZolUVuiGWb94AXZsUp6h1k65qiVonM6M3oho7lLXCogHwnCGrXJYTPs9dFqsCNL9qfr4Gbsp6TbOkeevJVlc2Ns2vV3/yAU6b7jP+EN7VUjuIuq5qaS4L5ttpq82oks9RraAzCLmkmfR3N6AHpHsl6x5SuLOOw8NkCXQJNBCLYaaaexolBm+DQxn5LfNvZmXDalfVnJgdL4q25nxL8Jff9OkA4U7yRaX74p9P4zIYrHFZOFr6UeEhtSxSbWaKX4f/CL+AvO+vJYP7urKoP3xJdkz6w6HaZ0OpZVgW/LvGPB5H3wrEtWbxVUcFW20bYW5g8QGdkAnwPTASRt/U/6wci3G/jiLFcSA1oTvtiQ1eXRDrR0Smk/Zoh779ekVyekj4LeoQAQaM
 E99eaV0m
 UALWeYF8XDRZfb/uvcbX7u53r4YdZghUkMbAHQRxQqTKQOfINRtj2wlOrK8bWbNYonFXyUpoCiiBQBdkeDLuaYujymSQoGvZs+EK+w7yOshk5HDSx/jhaMXbYQM9gMbstT4e5fzszEay6u3++ZZkm6qaHGn/B7MYYV0dkmpnCxdiUi5Bt5i9whAivw0Jm5AZ+IDWfotxvCHoEJyYXw73Bz63L2sH12UN4ZmxvFY4Zg+4LMey9ZlS5tvTCsUKqrGIOX0Y0d7P9wRUrzUAulI+yxiEMxixKc8BSVqxaNSjXxYBKHCM1fo6z3us05K7lYjLfd5Qv1Ept4OD1m9aNE1N3lrbSfVOOIHnCtRUvDTeXjJchJ5GPuuAtV/MHGmMK6svXp9hPmoZt7fGASaB4x445ZavFlqFiapuMpQCIscvr8Hqu/K5wosvL5MPBmfj4L3dFvyU/ULzPaUTI8no=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 09:31:43PM +0000, sashiko-bot@kernel.org wrote:
> 
> > diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> > index 592171ec10f49..41ccb618a1464 100644
> > --- a/drivers/dax/kmem.c
> > +++ b/drivers/dax/kmem.c
> > @@ -172,8 +172,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
> >  		 * Ensure that future kexec'd kernels will not treat
> >  		 * this as RAM automatically.
> >  		 */
> > -		rc = add_memory_driver_managed(data->mgid, range.start,
> > -				range_len(&range), kmem_name, mhp_flags);
> > +		rc = __add_memory_driver_managed(data->mgid, range.start,
> > +				range_len(&range), kmem_name, mhp_flags,
> > +				dev_dax->online_type);
> 
> [Severity: High]
> Does capturing the auto-online policy at device creation time break dynamic
> sysfs policy changes?
>

@David - we talked about this ~6+ mo ago at this point, i originally
proposed something like MMOP_SYSTEM_DEFAULT

https://lore.kernel.org/linux-mm/20260114085201.3222597-3-gourry@gourry.net/

https://lore.kernel.org/linux-mm/c4ed9675-269c-4764-86d5-87f4f83fc74d@kernel.org/

'''
   I don't like having fake options as part of this interface.

   Why can't we let selected users use mhp_get_default_online_type() 
   instead? Like add_memory_resource(). We can export that function.
'''

I guess the argument here is that the value can't be cached?

But we can't really enforce that.

This is a behavioral change we have to agree on (either we change it or
carry something like MMOP_SYSTEM_DEFAULT for this).

~Gregory


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B2D010FC450
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 21:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6884F6B0005; Wed,  8 Apr 2026 17:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6606F6B0088; Wed,  8 Apr 2026 17:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59D2D6B0089; Wed,  8 Apr 2026 17:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0F16B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:56:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00E451B71DF
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:56:15 +0000 (UTC)
X-FDA: 84636747552.20.66D2125
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1BE3E18000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:56:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b1C18HLP;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b1C18HLP;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775685374; a=rsa-sha256;
	cv=none;
	b=XRrsGZC4aKZhPnr1fkNRsL82a83BCIud2IF0KnYpdWeFWf24F2vCt/lw+71ic26o/clfRc
	RN+Vj6qUfQ9UgewbQsP7LrgcBvS0eqyJYy7Su/70s3r9h573kRlCIywzozsTnOPXHcEqnb
	pX4WcDnowFP/evYzCf6fsrY7OszPXOE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775685374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qndnJttoApFXUO2POEtVDoUfAMGPbRgoP3C1nGgpeNw=;
	b=Jt+WkmUShRkz/0jrwppBdZETtkfRb3lYDHSmeyljsqhZX1AZ0dVZIT4GmvzXOajH4Fk4mx
	MzhHigA7VKjUYPcMpoMH43GJ3bHwGMBmSWdixmcRjRUYt214266KNJpwllHwsBEfz9N5r0
	ag840taTk4xxAKFnyphnRtBktS4HkFA=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8a093c784b0so3666926d6.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 14:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1775685373; x=1776290173; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qndnJttoApFXUO2POEtVDoUfAMGPbRgoP3C1nGgpeNw=;
        b=b1C18HLP2+XqFmC7pW9mpryrX6spI/x89G43Een/nBraLB3enytVzritqxmxXHu82d
         rVf2537CrMb4BM64sc4iIeud17JBF9W4G1ZV31UASIlegM3n0kM2KSjpIf1ILRhw19x8
         KblrDvqwLzjaGoF17lwkXa0fZpTxwIIhKvfbaXIlu9zclySCkFYabmUOIPklz4BNsTVB
         NlZ909vwtsPBsutJwW1JnSS9V63nIpcKukWMw95qCZ/HoxqDGX/bxdZx+QdIeP3HbTN+
         FHpEDnReT/2MXKldwaRg5wzbF5pg9vAgJ+6oxREadMIon3FU045F9NEM8RNBZk1fBz5y
         zaHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775685373; x=1776290173;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qndnJttoApFXUO2POEtVDoUfAMGPbRgoP3C1nGgpeNw=;
        b=Cne4MLsDTANEKCzbANfsjnSljPBWAlMTP6CM19UCOuEr+2kzxu39CbBDw8syP6U82U
         cor/unZppQGfrs5996d/3FMNzEqzZcU8Do9Hp2NwuCCSVnJTeXXruv7wKBYtmgUmw1xC
         1uWoO6HT6uWFTcgqjgT0iS/Yo4CyRILLaQ6nzBt592lOQcAR7iKpGq4QHLU/L57KBj47
         l8mFah5R0eHSbgql46bk3Cj2hsd+JpIQbAEsTg2OH1APwBndONnl48WvRukGVGQtYQI1
         BUU4GonZic+x4MARwMw2wj9BCBK7deDk2XDLB52qJhpvqjSSBkIE47JazKmnVd+xALA0
         BFsg==
X-Forwarded-Encrypted: i=1; AJvYcCXALCvkN+0RFxvAeAHJkk5BkPji2eCkgY9pV1rSSpPzD6NqV8OC2aNxIJAFFvVGnVmdD0ccAWDQiQ==@kvack.org
X-Gm-Message-State: AOJu0YzYt64qu4iLx8VXgAISSG5BGXCtedEigxsCEfHcLfyXatmD4VNE
	5+Du1xdCwLBU5hzgt+LXA6iiCxDwuGvHUDKnEzGFO019Ov5qJ3t4iwDxhR2dS7rwD0c=
X-Gm-Gg: AeBDieuhlLtGkUonLqNYIfTnCtIJOEgNJ8G3N6EyOi3fQQIQoUIh5w4RBUxzIVEe6sh
	k1VQNWlGN+MZJ5M0wPWUEYoCHwCuBeLt62wCnJ01CfM2QVm3UJTyr3OjQU3JlkROU3blLSgYiUZ
	auARl4y9j+5puCw36ZoYrBCU8cvn6hxRXuNPKy7ctrz+qrxE3SpJvQX0LjjSHuHqfEs9aGXNbdf
	e9FvCvGYKEjtlIJLvqPUdQrWU9Z/UfY17dJtOy70b/JxAJYodp7/9hY//HDmadBf9CtgUuQRp59
	8rU9YGpwZeRTBAayD6Ub8r7GAIApTpJoJTkf0xR2tth0onkfq70ehVUTogA/Er+5bdkdXYOs+Hf
	7+ywpo2DBFiedULAs5kKgSFXFQkcmFXP7kgzWNelsqxCA9imfx8sn/x8TwGld3YXyTGrzV93vks
	JJI+Gyuh4as5jS+nyUSVbmiMrrqfTaGh+btl1dAFsT/YqhKeAYHg/Y+aI7sxD0jntD66UGaxlKU
	ecJqhcp+3Bt
X-Received: by 2002:a05:620a:1a11:b0:8cf:d565:fca4 with SMTP id af79cd13be357-8d41b8df4ecmr3283687885a.3.1775685373060;
        Wed, 08 Apr 2026 14:56:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d2a5392d35sm1601280185a.10.2026.04.08.14.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 14:56:12 -0700 (PDT)
Date: Wed, 8 Apr 2026 17:56:10 -0400
From: Gregory Price <gourry@gourry.net>
To: Dan Williams <djbw@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-cxl@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] What's brewing in CXL?
Message-ID: <adbO-tqwA_MJ1NHW@gourry-fedora-PF4VCD3F>
References: <69d5bf0ab2210_2b3110036@djbw-dev.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69d5bf0ab2210_2b3110036@djbw-dev.notmuch>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1BE3E18000C
X-Stat-Signature: asuofiwsuka9z49pkkqcie7ozq3zomty
X-Rspam-User: 
X-HE-Tag: 1775685373-42138
X-HE-Meta: U2FsdGVkX1+OQAugPCwYz9Jbgtn/urHYS93GW3i36Agf9kDAftbRTzGAM68/kg4SSZ5ytbDdwlG8lV5ALTqo2duec54BoKN53VEFRltWF31fwBnzIqCVlvH2gq8EJVATjzp7IhWtuhVtkSMEzd3QovaWWt51soetnwf+oe0fxHXTGwsdwYIsNip7der1b332VlfeNW8zc/lT6JC4CuFrfYbvHsoVZFf/+KPqvacT1WdhKd4Rubuz1TV9tMoE7lu76BTHA5dtq3Nx8nHZkrD6Jg6DZhoRtR5ulpcf7+ogAUS1qx4i9PSDEBjmhov2Q4CCH6NDxdqr13nK8Mq/PunlxHSCEx4zXc0bDTvGCPUCg4tCBbDub2E8XjU+onrdYBLZ2XQIh5tiQmwhJrTfdoxKxY5KO33nbDJBUzb1n4nTk7UFWvQrAfpuce8U8CGt+n+XZD9GBbu5ffv7sJv7KDU8fhApS2DIqoFyTN7RrgU216uceSi4gl4xs/0uQqxQ11lZybpG10orS9X4PLFN0ZAIYxt73IKm/TILiaP30+BRBE9aBolL9Bku/2jngDXnRXRENFjwblMnGgGrsm+xMhTURh7dYD79DRXMK0EnTP5xS3NxER/kIQ2ph3HOQnTHycLatBoHM/16dgpaetN/xJ3aWu7kpwQTBRyGlmea9tWk0PdyzMTwisdxt5ml8MKoYjeU4AYPUp75lrmmF9SdSUgoazItMiTzKihZ+RAlvDUQ6IKlrPeT8vEYXOdURwhAGsJPBdCraf5Z5qtbOM3lCE9fI2XajQiXtzKn13ptOEBgFC1ghC/3E2ivVsYIy/sO/0wkNIxtNrIH8JewzNJ0Vf10WTcKQIvc2G0s3xWT8ygeYSP6KS6vLrmjHqKvFJfd/HpCD+1+YlCYbNC3sq2AD1HaNBGSbcSFZWQ3ug4gvKPR3iWWOlvw4EUi1OGmfD+5z4b6ktlkIt4e7VuNj4+YLU7
 ++3D4Tvl
 oQdWD8A8TvmOxDNpcGl9huqqdZEocN+Xtl+w7TbMf+DD8uYPV7UAzjbXKyOMTtIWLpRIcTx1+qVvIxFXIfRVceXBNcRDl5J0L9JPRY74rPro0N/BJK5rsXycJrp7RhClmSmQeg1hGsHJvB3CPenCroJ7ul39TbPHh5Qz9Z+vc4zu869Epuar1vnbV+HSZEkgwnVRO4kcmfBEb/0kGz0Lv1haZRafiMksaqylW23nhf8Hd39mqueNgt5T5DfnilIewEpL/bJtsqR2FID9VuWkMCJRL6Vyg+ev+zLfVffN3i4rxc+wLSV9HsId1qhGHYAeFupQSv5yBJwsPQFu5qjo34LX0adF4DDMyLSbf9D06IBRwKmKXqJ40eAP87Q2e4uWLLc02A7mIFfhnJ+KwVMB26rs+1UYDHp3elT+R+KbrNZ/Z4X4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 07:35:54PM -0700, Dan Williams wrote:
> For the summit I offered to organize a discussion on what has been
> happening in CXL since Plumbers and a summary of the monthly CXL calls
> since. The session goal is present top challenges, address concerns /
> questions from the room, and perhaps introduce the CXL topics that have
> their own session later in the day.
> 
> Please do comment, question, ack/nak, or add to the themes below to
> highlight interest and help focus on the few topics we can cover in the
> limited time.
> 
... snip ...
> 
> "CXL, making MM problems worse since 2021..." -- CXL subsystem tagline

Acked-By: Gregory Price <gourry@gourry.net>

;P

Obviously I have interest in this space, and the private nodes
discussion is semi-orthogonal as I have been applying it to non-cxl use
cases - but i do think the framing of it replacing some DAX patterns is
a decent one.

~Gregory


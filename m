Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30403EA71A1
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 15:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59F086B0313; Sun, 19 Apr 2026 11:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54FBD6B0314; Sun, 19 Apr 2026 11:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463D46B0315; Sun, 19 Apr 2026 11:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34B8A6B0313
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:12:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE50E1B8976
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:12:03 +0000 (UTC)
X-FDA: 84675645726.27.42140F2
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 180834000A
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:12:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JQjDwmeZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776611522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELMcQZlFdeS4+itJFABeR3Hl864BgvTQvITeQpTy5+g=;
	b=r3eB0tw/E8W4iSqay3daESPDjhq50tkaHY+7FOPtPUVxG1tVzkXjmnYtXtoag4SP+FrTiY
	JzJsIqtIa6+QfMeIIdjWhIu1R9myA4s/RPVYWvKsuUK9Vqb8DT9KP2n7X4E2/HVJY8G8rj
	yG6X4aC8wMgGMgFzCpTG0OwhFeSNUHc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JQjDwmeZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776611522; a=rsa-sha256;
	cv=none;
	b=QvDTWo3t8CqaGLMDkWXmSvTPaq6kRb0D6eemylMT7Iuq/x6cB4gPzudiXC3mAjLZ8JxMyO
	wd4QwEDIDiWjggHU7yqWg5W/C9Ebr/TQF1aR+7W15o40PLWQMIvAF3jPgza+cgZF40Av7x
	yXlstACSI9FtChO0b7pjUW4hestAbBU=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8d68bcf50fdso274725485a.2
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 08:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776611521; x=1777216321; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ELMcQZlFdeS4+itJFABeR3Hl864BgvTQvITeQpTy5+g=;
        b=JQjDwmeZlm5aMqGtdut+X6s1eQr07UzfUmi8fBZScgTc6yAz1pAE8X4bqwhOMaZtYR
         S+vhd6cefi2mx+6ZxnP2llwGKXii1ku/NnvlYtMBpJ4X2HoyO5dszhXMoNej0PjWecXm
         6p98HQR6b7q2v6Op+gSCx+HSQgyMJ6wWOxYKebgvKxGdrV85kh5KqqtJ9fZ1+WtmANiZ
         Z9WkYzltlmH4rrBP+v8MmgkTO1j7yDzEf1TbwAsCUSZUSQuGw5CdfW4bcQ5Sc/zEuay6
         pxqsO8KT5dmPqCIeF/zVFspcLQaxuId1Zo7lhViYFZGNMqOCZwCdCTdoFFJYWs+ZvMmt
         wJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776611521; x=1777216321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ELMcQZlFdeS4+itJFABeR3Hl864BgvTQvITeQpTy5+g=;
        b=YnzodCqyouN0qDhLcg7OcKY8qfHBHddz3AN9nfbLTmrsxSKa1PmW9NI/UlbSxdrz23
         3Bo19lIP8VwEq2Svip+d6hfHH0O/yGyc4R+8jJ+98QxiFzJiHjCq/ieaBgI4J3s3Dr+u
         26FnzTPFJNxQLdIZCFtfDQSZ0NOtETRxnMSaHDpuv4iKZ66BFM+vvN3FUURdqiLA8jy8
         COX3/JSTOWRXG1YSqe6ftDrxrV4K05atMtXW+8ThOMriuupxbnAmQY3eOJtMZtcONpq8
         Xmi2bdpagpMtz+JjQ0oPbSEL9X6Msh6L60FELC1IZErmgsw7N/IV6R74TnmIJ2L0TPG0
         OdJg==
X-Forwarded-Encrypted: i=1; AFNElJ/9vRAgcq0hRhtvvA+xAjw4HUrowEYspEHezuH17U1Aw4RMyhjojccGf7SyvtsNbyhNZ7zd8ZGLBg==@kvack.org
X-Gm-Message-State: AOJu0Ywk2/X0j8ALCli7rOB3J64TpX0oqUk1T7cSGKQoa8c5msYI9Gi5
	pubF//7YvXMRFdah/CwolIhNrW9WihZiG7J1Fu+Jah8ZamItqR8nQmW+sjtrWaTQ6JwsO2rdLn4
	zNZ8q
X-Gm-Gg: AeBDiespYiQFUYg1M7ktn4Z11lbL1u15Az+rrmvhZfd8FPaBxlgxuwW2RffaiSBGhWl
	gnXcrXaqIo5QjYmdPCcZb1MGsD4qCuHKgcPYhWlJNQrbNATum8/uGseWrVoYoiSnigQxho2Qo7j
	doUs+Bnp4xlcJkDoFElmtIl9WJdYwrnwNcZjrLL8Ck3R1/JfIXE0QqpL5Qs4LTDReLF1Ibvwph8
	G7lb0gF5zia2G33DPCc69UudECqU+i7ErJKBuT4UqgLsolItMP1+wXksDF5NEImQ/RdsHb77cWG
	xxiVLPYtOkD0V6ashX3t6LXiwMb+z7EAl2hrWHWY+mISq6ivxDsDFeswvRatEteAWCDH+6iza0G
	vtUpF5d8aAASrJ77IWchquRgeE4bioqUkF7FuosvxTRj1kjLZX+f+s04fGYiLHukgi0JwYHaFaw
	EtER19Aip0mfVyniy9peNFQfuIpu/sXZ+JN/c2+Dxd8Mplau8Az4Z9YaCFH6G0
X-Received: by 2002:a05:620a:2914:b0:8e4:ebbb:b162 with SMTP id af79cd13be357-8e78f541532mr1351149685a.9.1776611521172;
        Sun, 19 Apr 2026 08:12:01 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d69ae320sm681145585a.20.2026.04.19.08.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 08:12:00 -0700 (PDT)
Date: Sun, 19 Apr 2026 15:11:58 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	brauner@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/6] selftests/liveupdate: add test cases for
 LIVEUPDATE_IOCTL_CREATE_SESSION calls with invalid length
Message-ID: <3vcfqee2mhtojsq4ujp2prb5kd3aj7hf5feegpbmkazibphl2q@rk25bwblttil>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
 <20260418163358.2304490-3-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418163358.2304490-3-luca.boccassi@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 180834000A
X-Stat-Signature: j6kgiushzuiq9ddhrnqhq4atjrzih465
X-HE-Tag: 1776611521-456967
X-HE-Meta: U2FsdGVkX18/k07W5XHq6+J9Dw5kRCu4lOx9Q9L9UuPLGf71h0mPq36Ma2zHLumj1S6xSt/O52o8HQeK93dHzsQawgPF8bn2GP5am6Xr02qfSPBGoxCpMUmRF2HfvQ9J8ZcfreTctbG4zKBcKWsf4qsdyOOx/dnC40MAKKXardi0IRAZTJuSU+xaoqnRgZ9f4oX39azmUNYCujUU38cFLySzhm57tCgyeummh4GxAzKWycIMbi1UZbnS6tVD44popBu8cLVQ4b3Yd/uFyRrfsXGfjs/iUz0bc+tlqgZBODvZySkphAOZjtNuuKDa92dJxCpKjYS0WgDscwwcfuPaGgk45VBvQBHJDqZn3odAIvQFTldsgS016J6zX4sayX99gfXQauZyMOG/aUMqTbRlfvjirBujBRYAERQwCBxqTqJZMtZsCC8sUPHRRnzoTx0EX4kWApTv6iyrBzwAqHZ6N5T1Yi0CizfQtiuE/bkb7Ghw7MoSRpRqtbFXNztNPx5ZSNszTalVeqF2MV7+gDT+6lhzFvHRxl685VSScA/AA0EAacIzbpbQWIZG8x9V/e4GXnkQz+uTZxCTsbfsFawpOOPOcLkXX6vf/58AzEI76A2n5tTbpQLz2D+mQ/E2vqZQ3PiQOBBpanx5KILauQY1MIgpm2FnJFjSC+TbhmWSclPSZb6mzaVWlRytaFmGtOsxy3jaGfAWrfmIqU2LqirAl2Mt3fBdWOSyt0rPWJqNHN4CjW1wL/LeURJpLetk8jvJpepEjwbOO2xYsh9rt02aE2G3AyxujjGUMgRUkP/fe4dJuxT6ubEb15f+5zpB04LSJ/SC6PMbNk1DReePynjLD+iGfrashjFNGAEf/T6n1Eg5BBLpjtwTbhHU8VTLPSStQlMHCWpAZH8z9loPR8/k34mjFmNLx/ET/LXPm098TDO9/KeFIefUo9OLrSC5PJTFeCU+mYSQiROU8IEzgAl
 iwn/59Wu
 +0do2KHr6ElS2zgC4hTYpr/QXS8xSZdteIOrx13oXdV6bf1fpvuZvzmaYvaFvUHopkTkFNwVYd/NEejz/premfvBh2Kduh/U1+qK+L1CugbG3l49YBc218cqb0G7O9+PfaUszyLGT3JfJmYuAgR9libnnbu5/Xl3Acr+nerEDjupVHGTaCHiA4BnC+JM41jfVGi6xeIXbD2TGaIp6D+nPnVhkbbBtiaP+NDNFVIx+YGvzGEejFtCCm8G0s6+FaxfQRGC9Zwc7sLOLfwW05Zh4JLLhh0+FVqNrO42qDBDCEE1r/wiAcHOhlEhGiCCHZC3O6TAhaFlJ+LeNNJCPKqzj7cF4/mvT0WjqmvmkskFMww1v1DrlzgUWySn8beo44eY/KLIgsmr0wl8+rtydK0KyXmwMWLuHQzYPHA2aNeDnzjgY/6WnRcokV5YjwWhHeOMeCap61LTfgnVlD1YrDrvipFSLxmAbDUm+BUT6w5PrsrKx4d0glqJb1I4xDdoZGRIzWTqsS23gk5u81djoC0oTc8y1XQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-18 17:28, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> Verify that LIVEUPDATE_IOCTL_CREATE_SESSION ioctl which provide a name
> that is an empty string or too long are not allowed.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 


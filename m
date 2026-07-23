Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73F5CC4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FC806B009F; Wed, 22 Jul 2026 23:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4536B00A0; Wed, 22 Jul 2026 23:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9E06B00A1; Wed, 22 Jul 2026 23:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DED176B009F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:52:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4967A1C006A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:43 +0000 (UTC)
X-FDA: 85018669806.10.9812487
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7541780002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KhYBV39A;
	spf=pass (imf30.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784778761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyN4lv/m1nCHBkc/YC4b5dQo4s+xkz63mLX0J0yNeRk=;
	b=xgBISMFUPmexlP8c9ScCWh7kE+fvopD1lVt8a0T8X2sDEYM8Ux5QOAxBx5fZAGktFqwMoB
	e8Bz9QxuJ/Etr1yUuUb0AlD1+F5p3IJ3dgy6V1HcafNGingqDjd809uNeCm0AYfpA+btiN
	S/ZHteb0CiGJbfBg6oP1SIilweZjeD8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784778761;
	b=XfnMZbk+Y/bNA1E2d8xSIAhWdObsm+xv7AAb+DdjeGi1heGAPO6B7RtlYO0ZD9sF+Se9Fy
	Sytp1TFpb4Uxz6UHZVQNxdu9qttUFaRM9PcsqULCLAmx+jNWTlvxxGPFfS6xxYSnjmRBi/
	H20XWCYOtITPlsXQyezy30+UntFsKY4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KhYBV39A;
	spf=pass (imf30.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e347638adso184478a91.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784778760; x=1785383560; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tyN4lv/m1nCHBkc/YC4b5dQo4s+xkz63mLX0J0yNeRk=;
        b=KhYBV39AEFnvE/dRfcA2pH4tKDdZighkkQodDp5VrWQVQawIMOrw+TcbNjQXqs8Sfh
         Nsq+YfmqJoWosz8kXHcN0nor3CGB6Vijyvc0p5Yuh7EPOgNmjc8ktpkVEPkCd4EOnCTn
         hcUYNrcR18Lr6Y7zvIziza9hXJqASi1S0Y05EKxnropeqU3utGXpWOcCdpKS/40XeT/f
         huYEKvnwAANAFDo3YjldbAJjlc5QZMtyVtZ14WhQ+HGGKVFLMgi0iA4u6EDEdRS5fjT6
         IwsQfj40mvKeYQ6LPEY3z1RzFMUSm14PBmytwoff1KJQ8dAmqmotpDE/T0fr+/lL7pl7
         Gl0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784778760; x=1785383560;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tyN4lv/m1nCHBkc/YC4b5dQo4s+xkz63mLX0J0yNeRk=;
        b=HSvnl3FaSaAKsYe89PkXpsP9lj+Kce78PsceMCxwzgGydwI+zAVvCVr4HdDgrNlf+p
         nlTscpCGX/ePSr52SLY8jwdSS8dELfO1lyxfFItr8gT3xqTbq39aaPAVjNUhhaRUbAd7
         /jshz43ieRbtehqEqq3Y0XRsLue3jdsTUBp6T45CR1wTIZSvFoCAKZ5O+NzO95gzDqsw
         kpWqM9cdsqEOYPulgSwlzkHdp1fHJCrtvgBtOCnpRuiesJDVmr9WBsxJK54KeJ/TRaxZ
         4eYvIKSzCodr+dhKauD3ztYHNOTpKXhiaT2mz0z1Tdoce9l9Y3kuWidUNbZX1H/ziGK8
         nW2w==
X-Forwarded-Encrypted: i=1; AHgh+Rqy/+AhHRbXpipsJlvkNI3rf3Hyuc1rAo6O8BukNHSABaLunMWzbDvVcPTppjwmSiPWiaBtyfRMUg==@kvack.org
X-Gm-Message-State: AOJu0YztiDFpnm7mX1Z8jFOTIobOSa3zRL/SG1pNweBPYXI9xs1wJyYy
	UwNpmnIVhEVTy7w02d2/n30XGDjJ6y/ZJGsJzAENOgUuit+dGocfJrfz
X-Gm-Gg: AR+sD13na/kgzovBPE4yR/fNzOV1d3Ve8+r01VUiblrPptF4kkfVu5h6+oQi13v9dn6
	SNY2zNrp2iU2QG1VL1MaR4wF4acYtty+hzS8CDwq6D+upobOI5FaUNgd0np34dgJ6PugbAsqeWe
	9YZtPZuQo10aQiSXixhfoiVsoaMT9fioya4px4LavcXTMVVqchDkyyfXDqm5MBoAVMtgzMc6NKS
	TtkmkM5LMFSoqRf3Qgab6TfQ8Xvuo7EMTyG1HCn/TwuK6aoemYTT8FYUEUEjPCTTVU6xCEvCK2M
	j7jR/xLKQHw1XD/mfu5Oi9SQywoWjy+2sWFZxjqKpsn/qwKLHdrEb/dVxPlyOYeSKg3vJGbEvEx
	aPZfIqtfJvQwITubbfDJnTQ5vwJ54esiFPMqmcrMCBsGkFaxW3QIKgNpTyGpf2JJknsGJF84pLz
	sSMHnqaQ==
X-Received: by 2002:a17:90b:1d44:b0:38d:dfd1:7a8 with SMTP id 98e67ed59e1d1-38ec63e1ed7mr1430578a91.2.1784778760399;
        Wed, 22 Jul 2026 20:52:40 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d12f267fdsm11497359c88.0.2026.07.22.20.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 20:52:39 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 05/21] binfmt_misc: split out
 entry_open_interpreter() and build_interp_argv()
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-5-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
 <20260721-work-bpf-binfmt_misc-ptinterp-v2-5-e57866e4ae0f@kernel.org>
Date: Wed, 22 Jul 2026 20:52:07 -0700
Message-Id: <178477872731.254289.5616585238630856872.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 7541780002
X-Stat-Signature: 96qeshrx83okrxk3t7m8ayrubn7qm1tz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784778761-19952
X-HE-Meta: U2FsdGVkX1/Go/aeaaKfzQfcdQxwBwZzJnvo4gRfedNBg4Sv2kR/t2Yhs5t/LSRLFHA/p0OcYueetHHZoBk9fV4jy5ZCcd9TNngl85cHM2yw4oOA59QtwlVebvtQqCXmPbF4HBd8z2nkF3vvG5yC0kw/+vwybX/KIMPc22pDX3HF27Xtit3w2e8B0fxfNCMlQJpKNXP6NQ/Kva67skOwDmOnGyQiaQgeTOyxsEDi4cH+Vjt74xPxKJgHkBjzV3hxPnsutSAYU1BUDAFGyBUHrSYfhbGyujbCRrFmc7BDEydU4wc0hCPPUF7IprVS6NcTA1toTruea4aNDKB2aamMGc+sox/mhYHIXVJJnKj8R1nHGvcW4eVdEP4UCxmCrQf3bxnsA/yGMf8gTcNPRqEa2/NGBuFfCeqaSkKHypeCmnAw6YJf/U+Pq1IDxizuhDlNjJ2Agwxurga/8o0PbG0DE7k3K7b66tOvwVqNSk3B6kAY4I282Bsmrq1s1gMyVU/NDwzNtJosuwSmfEZO4WDpLgHoZfCgynTKwqUz+Pb22Tx6p9UCdI3qf2NwMACr5n5I/QUJ/ZXV0NTAffoXsRMFLUFVWEhUHcYpSQtF+K7X7sihtuGZ8An4pqSwUlFsUEf9PKOSHNIHAjd4XWuhBiCYJIAd60Xwqv4HFvwu/Kk4vrNU2GlpZ2AnpHiXDrigWqxzpGKMUnLI3EgZN8tRuUXxpAT47IizttQ/YwWkGXQriVFi0HdSVSloPc7mRo+rlsxBVBC2c/QzlfRxzAOcIQMuQLJVcayOTsvSUPrkZyNCAAqUC8XFi88Fv5S++5vzfCtETBFjZ5KuyVzm+fV22U18c1ghouwkZ/S//I+45WBdxtKPH4ki4aZ731+/m/1+k2GZ62EUkGMTAjw62gOKGqfm2Zln4mLN/eibWJ27g2NRX+Kk6KDmUHCArgn0k/g+lwb2nVNqPOW8cqy2ZF+rzLY
 eBF14Tsg
 /4nN23KyRw9PSZJVtNAyIoUL5SfhkGbailU5J0iUrxEy9zIHAFeubUVIIGsvU2MWJYqZ/R4xUJ/RED+8Sq8dBtS8+5x93X2D4rwkYe8DlQZ9r7ps1Pp2tYm/WTEQ3/A9ux/JKLtZfYaPsqzVh0NYdbwgvwYYnrHz8NFZf0JHVlMH/l+Y9eDcfr2PhnkgmnFff0TVc6koMSyJtdyoH5jqA4FBbU3cCwzmTLjDEZbJtY22CxjAuJfsxHVy48qX+737Ugr8FM6y5iWKXKRYlNkmWL7GzyI4+21MpeA0Hpv4mSHT+P1IyBV2L3XBf1odQjsR1W8KIOC1ygnF7iMvfyV9AMqrJz3cbG/AG5qkQY7EQ0TJ46xo1t9NGaP1caTi8PVO4rUvviJYRnJvbcF5l6lDzkj6qWDKs+0VEBfRE79HMqvVcdKv9NCfJdlHk8PqLe/sPZe7usJqUjY8D0eoZPVV5W8DTtZ0Sc50nOn6/jV4B0/VhldEsQZ/sBVTsbIZ9L2Spau1R3dIuaDT2Ivla5SoynCMy0VwKGNiCnYDMuC0zESVgFOOM0WrTytiVlAzNxz4AvJSN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 16:13:47 +0200, Christian Brauner <brauner@kernel.org> wrote:
> Opening the interpreter is a property of the matched entry: an 'F' entry
> hands out a clone of the file it pre-opened at registration time, any
> other entry opens the selected path. Give that its own helper instead of
> an if/else in the middle of load_misc_binary(), and let it fail early
> rather than carrying an ERR_PTR through the successful branch.
> 
> Building the interpreter's argument vector is the bulk of what remains
> and the one part of load_misc_binary() that is specific to the classic
> dispatch. Move it into its own helper too, so the dispatch reads as what
> it is: pick a handler, pick an interpreter, build the invocation, open
> it.
> 
> [...]

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>


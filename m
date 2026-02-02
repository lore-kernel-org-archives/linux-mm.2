Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB34E7DEF7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 16:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1043E6B0005; Mon,  2 Feb 2026 11:19:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE966B00BA; Mon,  2 Feb 2026 11:19:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6936B00BE; Mon,  2 Feb 2026 11:19:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DB29F6B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:19:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DF08B6F62
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:19:52 +0000 (UTC)
X-FDA: 84400027824.28.2A5121D
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8F226140006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:19:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Mc3uKk7Q;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770049190; a=rsa-sha256;
	cv=pass;
	b=OkMw7nUgglB3yOI/0gtcnlRqDaapRdhfLdW0HDVWwMzOyVcRRx21j7C3fpYqIk6hn8slWV
	7p0YUQ3etFoI7cctSECHynIGp5dGLDyG+FIQKAqXEr2yBC9nSDP7WUkhYYLw/c5lbVBVaZ
	V9hYdGgNcoSJLZ1WP00VGBa3lt5C5Oo=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Mc3uKk7Q;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770049190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wA1o/Co+V784yYc7kKaQ3dZ9Xgt1av7TFvzMkqxsl4=;
	b=ZVs80yDOHnt4/tKTv0Y1a92MkpEpz73tFCwV+jBjg0Sz69A4nyomytzavQRmS+RUdp6Vuv
	ZNTdrvKQoxIkGbVR5G5j3KG5w+hHE2ulTZ0mhEWT18aUgKq+nhmNtLctaozgfYBK2qVzc7
	th62Hg27evK27bmdn1kQXLhpNVVGKPQ=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-34c868b197eso3370027a91.2
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 08:19:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770049189; cv=none;
        d=google.com; s=arc-20240605;
        b=MwS8RyrAFmNlLrcfyBWbQA8i9ElD6Zmh8UAZ2YwYnZf7J7liGssoqiz5Wxi3pr080k
         /GY7Zuzx4e1bD/FawzZk89a1wAUXBPjwJSBEik8iMBUxrwYZ5aTtTgI0TAv1KKECUTka
         IkOiQqDfPXk9EuydVeIJcJjPDE65LArfaCfchEQarIgIJKg8oyhbA/HBsuVX0QGaSoSv
         OxHWkoMOFBRDAheUqX4Uy2b/3HihDFRb2JPIOzSr8WmmKMUQSupVfMuld6zllSsdRE8H
         +rycUsq4FLmSFXne7D+04TSIHXGgX0GULV8C/JfY1bLFxFdxbxSPuhiBTbkh1N85ZjEj
         oo1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9wA1o/Co+V784yYc7kKaQ3dZ9Xgt1av7TFvzMkqxsl4=;
        fh=uBTk/+HTrd56Po4NnZgC+11uoLmnSgHGa6kT5y6FdqE=;
        b=D8UQ7LIOkgIw8se2s/vGcqJpEcgX9JO7e+TdFMNpyMSNYzMvjjgn5mCaG71sIGFzlQ
         EXMDrmLOznq0Io15xuDU2r1DuHNhlP112CJV8lq1VfqsCmoSFTSqZZW9pSHF3B1MrP51
         AY91AILZNpk1DL2924cLiclT/DPVVFsUD0l9Yto1EHO8Xq9Y2ei2JrDiGifVq9xP7319
         pRsb5bxDzdVHGHpoA2/pZt0IEfXQc2MlKDb2m9xNrkgHhOp3GjvqyMe6qSTt7JpEvm/o
         Rtrf2TMQXpfTReOArDNcX9HUlMvkg5F9LaSXI9cXyzkhh/jHc7gookTBhz5IlsWSHNWc
         ZdsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1770049189; x=1770653989; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wA1o/Co+V784yYc7kKaQ3dZ9Xgt1av7TFvzMkqxsl4=;
        b=Mc3uKk7QPsQRas5EWmj0xP3ggAHmU4fyWx1d58XQORXXD+ZEKSd4JHresjUlJGqD0o
         jNjtJM2wgRNfGJNGucOm/OHTRQmGVlrpvVeCOBb3izOTNfEr13HabvyVlHqMX93Dh9a8
         o9lZkhmLTwwTR9rB7RLJa1p4auZmGux9S+idTLIG0cn8K80IwPC4bwNigglxxu13C1YN
         Y2/vfCDoH7Q6lDdU/XqtpP2CHXtYmpYlYkzsZMmPPTtIWPiBK4DXF5Nx8ICY08hpCICN
         f2uBbrwbI1bwnjAaxC5ULi3Zbz6jBQQh7a5Z+9M/MpJA/MRyT9dCPKv/f45qTQ+MMOug
         RrRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770049189; x=1770653989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9wA1o/Co+V784yYc7kKaQ3dZ9Xgt1av7TFvzMkqxsl4=;
        b=jwMD7bMFwqcsqB9QNnBZY4kdnNP6yUHYh63NcvAwtLEiB57Vny7iSWueJzwUZ3gkkL
         MajNZ2LAXDZVUoA+2qKjj6vfyRirNG4SsMiA4ymL/McNorxiU/iRn9/aHdoUalE5ZMXk
         SVgXAXBuAn95S0i0cU5CyBUbmrntLXLq43iWdMNFmFj6Mm2Kr7xDxwNRIobRnJNVl/6v
         v1g51fLryYGhTFzvyEqA1wQ1LDMVkrwzEG+B10qwLG55u7iH1+oZTyetX1hnbPcm0E1p
         cDg1r/6qxXefJAjN36a9dFc3sZXayQu7f5VJaYXEy2GMkBno/gtChxrPjEbqVL6H99Pd
         UbWw==
X-Forwarded-Encrypted: i=1; AJvYcCVI6k6C/O1OA8J+2jtH8loAcwy/IikhEJ7aGCLG0h4n4ePSpjzUAsJnLx7NjOo6KJM6xjMxjmXfNQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0OK10WU+JvZnD8DsWxaZDNj98T+1UtmrPlI6dXzr5JF4wP11e
	hWqps6zMSmCosSZj5cr/n/NSG/sro8Wq/p0ddb8/5iWIinwiHUtgJgeLxtF4NuJQ53PBnmVNqky
	levDE5b5PO+YqYKom+STdqF1/oDl39/szoBHASppL
X-Gm-Gg: AZuq6aIlkZbRjOOyiraO6zc0BzZnn5Ge3fE08mljYB0V/9RBwywT15YDBgqcQKiIoK7
	yHkmZAv/JVcWLSCDd8jyYAn/WRWfMyA6jYZn3QKPGXxnGfuaYpCgXOrsbBd3sBcckasf96b6o3O
	SS1N+87QpNQn3UhHFM5jku3DNk8A97AHjW9E5PhtA3C+etftHwzDcwGAUJ0I0Kyjr+715jaQ2b8
	K3jX/3duwe2B6DpnElenctKoABLH2Yx35AVKuxo8v+R3z/BXuleJjuteK1f6Mqvbztuxr4=
X-Received: by 2002:a17:90b:4d09:b0:353:e91:9b38 with SMTP id
 98e67ed59e1d1-3543b3bac1fmr11445640a91.34.1770049189348; Mon, 02 Feb 2026
 08:19:49 -0800 (PST)
MIME-Version: 1.0
References: <20260129225132.420484-2-paul@paul-moore.com> <38c9c9bf-3912-4e16-b15e-60890390e8dc@lucifer.local>
In-Reply-To: <38c9c9bf-3912-4e16-b15e-60890390e8dc@lucifer.local>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 2 Feb 2026 11:19:36 -0500
X-Gm-Features: AZwV_QhMxqLc50o5N0wo_jmaZh5-65SXwNGUuFUe1GvxMvLW0htJwjrZAphLdnQ
Message-ID: <CAHC9VhTouFsjWA9QeB81HEQEQRWGfyH9iCo9xZ+NyMTbZ5BpQQ@mail.gmail.com>
Subject: Re: [PATCH] lsm: preserve /proc/sys/vm/mmap_min_addr when !CONFIG_SECURITY
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8F226140006
X-Stat-Signature: 159hw5rcdohyq13ujdofzfrk59uz1oaa
X-HE-Tag: 1770049190-371025
X-HE-Meta: U2FsdGVkX18czG0/Ehc3790kDTS0eL9pqpabmBh966an04jfpHphW0p8TRaDxTu0isj1jDKotOowEhVH+ZS1lHr2m9KEpZRxdYdRIE0ySXzQ8vgwaSSOyyySEGSnlbHqnBfKg/RF41ABf1BsJ8XPoHaYMuCnFmIH59tsVnZvwXHng4ks1hW+PH5cHmgKOZnplbWia2AP/8O/JWhFMZa01MC8sXhM2744+LhqlTZBqJ8BiUcSBbhQJMSyfGvYee7RiAtmV0A2r1p/0DmY/QfO3Z3mzbZqjLXzSA76MG94jzxlSSmkddjkwS0Bjvm1/AnVOG5gKTcn53Ma47/rny49UXuhvKgZyXsNNiVPD1uEIzTpF2iT2DxseZXSnLV2eYUsRfpSaDI85hMkB97wwAvEvvg6vUSHxM+VTGNfLSFwSy0olERZfmdGuOsTDNDI5EkTac0/D9MNRYcYyzVm4eeH/pW1fAfVOLLQLZeiS8bpVKAoBVNLJFZg6xkyYUYnSI0DPXNsu0jWZEwQwsGY4Cn5H/eAo1V5VSQ0yc0GJaogAfhiu32HoSu7lTUbwKPUsmkJhfoBTQaDPHLizC20TjFFUTWsRfKEAdovdfRxbcUZTvepa9aEbGMAmA9ohRtH/RQgRwOKEdFbXsL28xwWM5zg+RMUy+lD8kOAUSJBWsrGYsDqy7TIResypPtuGvmx5aeFokAM7wY48JdbGTZYu1GbcfvElPvLjsHPMmPoGjB0pfiCDJNcySIJv21L48kcjajbExwWRDWrJN0xr0l6oANbfPMfbnZiusTtvycFiVz0Sqfxyey3K2OxW+jcXPBo3Hvi5KdOsUSH4NahrVilXJK8JCIOdu4W048yeMsb7fGvog1kUPRoi+BPrHANH+BwqoQLORoPH+Z726kVvX2QyiD39wxdrFHmb8vzBgsucyA9q4hcKwkczETYFdB64hsjZgBSSqa2ulMLAXo7Mqcd3yL
 Fy1NVRWK
 F0ctg382k0Yg/IORXFpJBIERrON+IgB/X13mbP2eQ/NxorFNVpTcW4W/hK2mEv5QX531I2X91FzoaSu36Bh1pO2+RiRuHUxTP83L8f58m9PUeOEXnyZegeMUsCdpGHrIM2pdXULZ/hA57RuSDbtHFoeEHqb2oAZqVNfORIynjOrF9a9xOYaMLN0dJgG8T997R9NLDuVg60jw6ah84QWx9RBzbdlbolPnJcPvIo9EzU+hNbGMfKsDfa9bCtDT6C3zwp841Ua2Dn5kovMnHZMpLTBSln1BLXFJw5vEzEVt6kDdyd22mgpElNDR7JxqRIHNyJyFu6hguqBh8hZc3kYaQ6USNX6lkJtWikgzdJCkPCzfbTvkg+/O/GGAqG2DN8YxECM4ycUQuG/CEZQw5gN+geDOqeq7xLB5hN0iesS51pTKOStiBjVGkjCbKnFbJ9FWSu2+gHLqWe575r7YTrWjXrth0fTXkgcmqNO3v9LLTeLX27JhcYzPtni8htg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000023, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 2, 2026 at 5:53=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Thu, Jan 29, 2026 at 05:51:33PM -0500, Paul Moore wrote:
> > While reworking the LSM initialization code the
> > /proc/sys/vm/mmap_min_addr handler was inadvertently caught up in the
> > change and the procfs entry wasn't setup when CONFIG_SECURITY was not
> > selected at kernel build time.  This patch restores the previous behavi=
or
> > and ensures that the procfs entry is setup regardless of the
> > CONFIG_SECURITY state.
> >
> > Future work will improve upon this, likely by moving the procfs handler
> > into the mm subsystem, but this patch should resolve the immediate
> > regression.
> >
> > Fixes: 4ab5efcc2829 ("lsm: consolidate all of the LSM framework initcal=
ls")
> > Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
>
> (Sorry was at fosdem from fri)
>
> LGTM and tested locally confirming it works, thanks so much for the quick
> turnaround! Feel free to add:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Cheers, Lorenzo

Thanks, for the original report, testing, and extra set of eyes! added
and updated lsm/stable-6.19, I'll be sending this to Linus shortly.

--=20
paul-moore.com


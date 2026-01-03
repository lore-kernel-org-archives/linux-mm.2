Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C955FA3750
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 11:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5406B0005; Sat,  3 Jan 2026 06:33:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573456B0089; Sat,  3 Jan 2026 06:33:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F9B6B008A; Sat,  3 Jan 2026 06:33:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 348066B0005
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 06:33:54 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4CD3CC230
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 11:33:53 +0000 (UTC)
X-FDA: 84290443146.01.9AF9DD5
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id BF2A480006
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 11:33:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B/G5Dith";
	spf=pass (imf02.hostedemail.com: domain of sudipm.mukherjee@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=sudipm.mukherjee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767440031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ufcefJVsovNbptadQDCIANuVGLP5nh4jVV/94BHGrao=;
	b=A9ja4r6Zi9j3uOgxAWI/pya1se209gxKtIIBkyIpECXsaUT9Hc2QDD4XlsO2elKTPAtsoc
	mBngkifmINPIOvfBMWeA/Sqr0JnWAarmvzsFR80to0d2ThVV01xniyz7KudXnWhpX38LYF
	v9IP4ri5fwRz0O+xNa/mrNWmL/8zih0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B/G5Dith";
	spf=pass (imf02.hostedemail.com: domain of sudipm.mukherjee@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=sudipm.mukherjee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767440031; a=rsa-sha256;
	cv=none;
	b=hrx/ts0PP2H4KKLPnuIx4fb64Iqztlng0kUh6NnQeFZF4XWG1zFkuWhsN3o+HCTaUdNYHA
	DiLsLPKpdcgY3X2t5SO20/4JDQOBdd+RvfAQBGz12j5b6sxXyG9p35GIfOrhmC44kq3Cjf
	S7wqugS+lh+BeV41/ssQgJqqSZyqHps=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47d211aee52so9070045e9.2
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 03:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767440030; x=1768044830; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ufcefJVsovNbptadQDCIANuVGLP5nh4jVV/94BHGrao=;
        b=B/G5DithuAsLf4fuMltMDFaYMTLdz3iI1wQh/s/zzZyf+8GM+IX/no3qB0QQmo5sST
         Km3TJyusBtCS34U/ZgdegvvB0ORWckNJZd5D3cuT8CVEnSQNYyETDsnFbus7X8DS2wBF
         CdJgl8YK7Wy2BmZ8Kmc5JhIlg6l3giofB6qnx696BN9v6/xzeZtFS1eamiSydeEAh06s
         MTVzzPqqZvZIX1jhlAVKY+6qb1lgOZEMVBzzu4KfclHLJrjLCw+6XLIPy8Dq6h5Fc0di
         DxxGg17slhjjOKFHf0ikKF2pfYK/z9eHH0BXfO6/yRdTijWwXccIXXob2bJtlpVdzlXn
         Tdlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767440030; x=1768044830;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ufcefJVsovNbptadQDCIANuVGLP5nh4jVV/94BHGrao=;
        b=pXq3mEPakeEcE50CbMoIHPgdgKeaDz1GHFeqNbQCbMCfb2Ui3EVqJtpYDArAZC6PNV
         rk547zZulmmLhyUgltRhfRYz+a8ECQfJX+dYdVqS+NkG4CC1nxvQMGKVBu9wlBCIlFqJ
         qfVllli37LiXUpneWqm6QZlx/jY1x1oZqpC7aJ4nfqyFra6PGLnX/FB85etOvTFuJCkE
         iBKxLNsKnJ5SHEjVe3pDYlv9Vfhs9gXFdBpBzi3VaOSNqbVxZ5Qr1Ev048UWAB1pjhyH
         yq5hrdonZMjX/XLsYmNSG0zsBTicLXkg7Ix4pH0ITLUC9sn7WOuzU3QV4h7KfztrHuIJ
         9twQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQH4KzJ5ICwPxjVpmFGBalNmuUApZh6054BoGohuS6ZxITTYcDraifdv2JV3+WIzRDLPFbQraMGQ==@kvack.org
X-Gm-Message-State: AOJu0YwlDND0XP1KBMfoYxWKejdXjphhPwdSw+WDB0cOfdXYo4zvvASj
	+on2uXOdL/rwSfY+XqeMLyy5gjlsvlVrFC9Hb7dGwKjecGts0wRQ32mM
X-Gm-Gg: AY/fxX4KztC5EkPwJDEGJmSaqcSnRPguHM+5bq2TYRBnZPaWDN+uUJUWDZzDMGZdaSz
	pwS+K48szqbObR8Yx7yaSAd3DI7yxIbxkz7tYLom2SCBNLQ0QHSbHeCU8eWctVTbIPYspLX0KZB
	FP+r1allccn81etRozpLvA6EMbwWbTZKtlNb6MLyXRZlZBrTQA60BREMR6li1t5fToFWnT7ZbP+
	Iq28Yyry2WGAd+/iONKu/UM7SRRYB2AypT2BFn48lC8tkdgmVZMVKkvC1hJDwIYKUZrrZjq/m01
	toAMn0ug0dOGsUsIxpJX+5Gdsh8WdEjThbZ1G2v0bAEiAbRseMLMRfYmkzqIjBmPO38XE6dufKO
	5s/G0hZSKVbDLygd/FEt9cHCyXb+lJiWlPaFwMsnv1kBTn+07PFa07ANMF+w41pgp7tsiluNP5o
	Cvmz4NzfrEFFzCt0FB7a0KNQ==
X-Google-Smtp-Source: AGHT+IH3pBngYGrXfax3dXFTdYtopPEIucZI6Xy95b+JVFKyiDopAVgfxaAI2m507ZcWZ3YvIO71Ow==
X-Received: by 2002:a05:6000:4020:b0:429:bde0:1da8 with SMTP id ffacd0b85a97d-4324e70cadcmr33580502f8f.7.1767440029849;
        Sat, 03 Jan 2026 03:33:49 -0800 (PST)
Received: from debian ([88.97.178.141])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eab2a94sm89501609f8f.43.2026.01.03.03.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 03:33:49 -0800 (PST)
Date: Sat, 3 Jan 2026 11:33:47 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>,
	Salvatore Bonaccorso <carnil@debian.org>
Cc: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	regressions@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000000
Message-ID: <aVj-mz8vaw53TWtX@debian>
References: <6ba903ad-9897-42bb-8c2d-337385cc3746@molgen.mpg.de>
 <db387081-345f-423a-a0ff-e13f3bec2d51@molgen.mpg.de>
 <CADVatmM_mRnkDX=hpUjbyKkZnGynxJfRSujGxm2LaWWMEL_2ew@mail.gmail.com>
 <ef9223ee-0a4e-468c-bfd0-0cf190d262f1@molgen.mpg.de>
 <aVgjpWaIRkerdgCa@eldamar.lan>
 <49cdd663-bcbd-48b4-ac38-77ce94ef0c8d@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49cdd663-bcbd-48b4-ac38-77ce94ef0c8d@molgen.mpg.de>
X-Stat-Signature: y84io4nwawrykqs6mydxxkgmo6nuock5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BF2A480006
X-HE-Tag: 1767440031-77289
X-HE-Meta: U2FsdGVkX1+PF2N5l7LJtd6ljaYOnrpb0JnVRlXzer5JKsF/L3fvY4AFJkitw+BxFmFyXMP14FgtKF1p9Itw3KAgp6nUD0u0ZG1jjtfhTlnTpmAwCEldZFuizF7/eaT4Dkfw5OlwX2AdAdVch4npue+pHKx3S+xeYJpxZklahjJMlJ9yR//lSeHdmgsg/W8SLHPLuHiS2WBkoc53g8rU1iQQv/u5KFUMaSSWyTw/N+B7j9iQCX280UqvNcqaL+igra0iUF39FBlCE5juRufz3EM3ytSBIPm8lpzUxLuvwT+WJoC1jipCspY8cNZVVij2JrvAp+QRSEuo5PNLbYLW7xxiy1+2lPeXrigsNPdtWckt1HFt2QmL29Re4XrQtGMaXv36i+oCh0hpgFkYvFrIUHkoSMcoq58umKpyBQSgSAz27QYT+pmTCu8Q98XNMptzka50pXVNGrgwG+nwgcPZJoq+7jOVcjMUMXFpHvlwjy+ufkxoPxrOK3eBk8CxRGWFEX9gnOHR9ZX59z2nO28k9Q0EcWL2unVNJtN30p+HaCWg4OFPvlKXDbQBYYOo4RUL1fPZiL7bKXVEJHK6p0QK8TVUUlCO5qI7dX96sYEQE2zBmHYU1g4XuNQ1QgIZ5FjOEIDSIf1mK+3pypTHRpQCucHx12X2i47RosADiJ9142Usrr5JIMA6gAgloGx7RyHPR20nXSmxZpLqnto12V/xjiXCPHClqzz4ldWWNmTnx7YlNsnSMmHiWxwEfjLHoJgk3kN/aprgetJR1qbERPgM+HytgsDPadsxARcnbpGZ8io0FBUk61/lST4UWwrPpsboK5v9FgYXjV9886RIxh2XvvkfH6XTbCp0I+BCcZ85GBNXmjDLzTxOqTOIOLMrTotqGxRi57g9yzVgw5kv+lTZNSO11xaj9q06Y/KNdKZoBIKS+kJalPFvy9+s0QmTi3gnKsS/sIeycGBE1p8lojZ
 Kgxthn5S
 nGKO7fYOZc0/w37Ue3W7hHi+0wuKnNP2WD3HIDArrBr46lqvpdzvDP/YlxCpTGpQIwMt80qbjBTOUIcAJuOv4raKGTlV80rvPdfm1Nd0k4Xii9pekoyLOnobYKhpxh0+40nCSu3HCEg1ac1T8I4e/3urmdlViCJSAatAOKqcPXhXC2+cdCwZpga+Ka87Gqi5voaqwfwSOsH5AwoSIKxNm6HM27TceLbSSSw+j236NCjdnvkwsFC0yksQQu2vEuOLd5bDO1sbTDw+mAXjW6QqrSEBIjBwFbKPrFCPNP7bYtSclZOw3+r/HF8AD8n2HgN+3Jf9lJA45LJvRzV2Cvc9feyzl7GEns/AEtFTaTN6BngGyIwX2ifqPlilXlAlGXxs1DFw4W3/R1q6T948GVJ2OgEb73AZWs1Zkvs8h7XFlB254puw4tNpMP9RgrjNWPVBkHnwHytoOWtV/k3B+7wmHMfShHflxk7ojAWYGUkO8p09RmvohcjAnx4Pb2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 03, 2026 at 12:01:19PM +0600, Paul Menzel wrote:
> Dear Salvatore,
> 
> 
> Thank you for the follow-up.
> 
> Am 03.01.26 um 01:59 schrieb Salvatore Bonaccorso:
> 
> > On Mon, Dec 01, 2025 at 05:05:59PM +0100, Paul Menzel wrote:
> 
> > > Am 01.12.25 um 14:25 schrieb Sudip Mukherjee:
> > > > On Thu, 27 Nov 2025 at 22:55, Paul Menzel wrote:
> > > 
> > > > > Am 27.11.25 um 19:51 schrieb Paul Menzel:
> > > > > 
> > > > > > Unfortunately, not reproducible, but starting with Linux 6.18-rc7, I got
> > > > > > the oops below *once*:

<snip>

> > 
> > https://bugs.debian.org/1124075
> 
> This is
> 
> AMD AM5 ASUS ROG STRIX B650-A GAMING WIFI, BIOS 3067 12/10/2024
> 
> > https://bugs.debian.org/1124463
> 
> This is
> 
> Dell Latitude E5470/0VHKV0, BIOS 1.34.3 11/20/2022
> 
> > Does it make a difference to cold-boot or reboot into the system?
> 
> I only did cold boots, and I am not able to reproduce it anymore, and wrote
> it off to some hardware issue – despite the system working fine otherwise.
> 
> I am adding the x86 folks, and regression lists.

Thanks Salvatore for the Debian bug links.

I had been trying to reproduce this but have not seen it on my machine so far.

But looking at the traces from the Debian bugs and the trace from Paul, my best
guess is that its happening because the low level driver, parport_pc in these
cases, has not completed setting up the hardware.

When 'lp' starts registering, parport driver will check if there is any port,
if no ports are found then it will try to load the low level module.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/parport/share.c?h=v6.19-rc3#n198

As mentioned in the comment request_module() is not trying to load a real module
and it depends on the alias. Also, mentioned in the Documentation.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/admin-guide/parport.rst?h=v6.19-rc3#n45

I am not sure why the problem is seen now, but is it possible to test the
below diff please and see if that fixes the issue.

diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index 427abdf3c4c4a..8f45daf7b3825 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -287,8 +287,16 @@ int __parport_register_driver(struct parport_driver *drv, struct module *owner,
         */
        ret = bus_for_each_dev(&parport_bus_type, NULL, NULL,
                               port_detect);
-       if (!ret)
+
+       /* Return if no port has been found. The driver has been
+        * registered, so whenever a new port registers
+        * attach_driver_chain() will be called which will then check
+        * all registered drivers.
+        */
+       if (!ret) {
                get_lowlevel_driver();
+               return 0;
+       }
 
        mutex_lock(&registration_lock);
        if (drv->match_port)


-- 
Regards
Sudip


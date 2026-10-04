Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16232CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 18:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1BF6B008C; Sun,  4 Oct 2026 14:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053536B0092; Sun,  4 Oct 2026 14:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83F56B0095; Sun,  4 Oct 2026 14:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE5056B008C
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 14:46:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 669851C3FEC
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:46:20 +0000 (UTC)
X-FDA: 85285824120.12.1D7AD40
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf08.hostedemail.com (Postfix) with ESMTP id E3ACD160007
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:46:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=cPsT5ZcH;
	spf=pass (imf08.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791139578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9HrLouAe+9dAbXUMKxgFdSHX5a0LnpsaBifZX7zcJOM=;
	b=wFmZWyGf34Q0ZP4EeFlBOk7N7K8fj3Kak4M6lLI4jCzalvcWYILTa/Ws7hfuQY152+QxT3
	yMsIwRY1dvM+XmOwT6YC4QWtOggIYdGw3MqvPnxV3Y9EbBDz4PX1oeCK/u3NhPBLbZfmQJ
	wDezfFgMF/qmLk3htLR7v8tulfXFPXY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=cPsT5ZcH;
	spf=pass (imf08.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791139578;
	b=sn7KTWLEdnvZkETHGUdAGVaaaW4X3FFanMgJMAxTL8nDvD3ZFT7uDjVwKrFXwwOkl4BVof
	48xBiaG/aFOxmIcCSowCN5yieFpOuPbB+TXgX3Rv/2C9TBaS6D7uOryaeKIsgf01X5jKvh
	vW45P1trGa73a+zqX+Pjm5HdGwzhvwE=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 694IjpYK4062391
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 4 Oct 2026 20:45:51 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 694IjpYK4062391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1791139553;
	bh=9HrLouAe+9dAbXUMKxgFdSHX5a0LnpsaBifZX7zcJOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cPsT5ZcHW36/chAnpDmGiHAT7yG5g4jxV+GDs+8iYhqbX/hH1mXRwGzbJn2+EIHQ7
	 Fz2NyGs083JF/pboieVHuv1Pepeg2TbjhAJD/ine52TroiGHRt4Qy9ptLk25AyPUXl
	 HHjM/gi/1u0lkd4L6jrlbCLw8KAEpyjx9kk+JGlU=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 694Ijool022808
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 4 Oct 2026 20:45:50 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 694IjmMx2331923
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 4 Oct 2026 20:45:50 +0200
Date: Sun, 4 Oct 2026 20:45:48 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        david@kernel.org, Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Tal Zussman <tz2294@columbia.edu>, Rik van Riel <riel@surriel.com>,
        Matt Fleming <matt@readmodwrite.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <asKe3M5VRvMvdY7s@pcnci.linuxbox.cz>
References: <arde/t0zQNEkWqi5@pcnci.linuxbox.cz>
 <areOeRwZOez0eHm7@gremlin>
 <arotyz5g6LozSjb1@pcnci.linuxbox.cz>
 <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
 <arzRBv9ceJsxJppI@gremlin>
 <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
 <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
 <ar9yRqq6cBxHDWKA@gremlin>
 <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
 <20261002220248.GJasAqCFwxOK4l2TbS@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261002220248.GJasAqCFwxOK4l2TbS@fat_crate.local>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E3ACD160007
X-Stat-Signature: hyw3gxou8p88mqu8ct1brdaedifgmoje
X-Rspam-User: 
X-HE-Tag: 1791139577-1436
X-HE-Meta: U2FsdGVkX1/D1HEl/C0eaMpSYoEY91o7PDo4FluD7zu84Ad3rlD63VJBESVAR+MqYsNiYPlIIY5UqXSio5lhOhhqli2oiNGrd40tKZNKTS8kBn9Fk19LeIw5I/Y+wepYej4sMGSTiMRHtreg1F+GsGjv/zImZX/B2aY4EKBOvLaT6FV5zmUI3L6bQB85G+IucHCNVyi+Ka+9Bw1fuxFUcgMkkaoOMW69VoiFFFFJyv9wfG+ZJczNj2zs4OL1TQrqCBe5iTbPHuWcD03rOZpWu2KtYBqT/M4+5F14hqBywJ7t8xBB2KMud0CZwen0H7FqDDhEidZA7eCZ3/LpqaKda5H/edlKHO0tRbH7zglguyI0ItbF5+0lrg0PEyRfWSODAlPRqNz4IEOEy1Bky980RijF7y7joEtJnuaj1tm2cxcV40MOvHVxotZmAqccYTdLdANOIIG6LHtiDRDHXedJUTvwDds5poovotsWH8OX6nDICHo/tdXQmZEj0PWG2opm2MhWP2RI+AbKqNaC0/IIQKdt7Ic70WrVlrI2qe7svjFoyRSv4uqeWioOFeJiHon1/rkVanHuTzHBM2/4I/5MXNn2/K8OYlq5Z59EshJMqF7u5OQKlyJLrzAQxZjxY2AN15474Nl2Yj13qABH3OAbM2w+itmsA1e6Iqt2a6alzn3ne+EbXRtdGgbya5ecrK/qBySn9zyjEwHY0VlPB2svGSoA+1di2LTkHgNwl26vtFacWsZdNX/okCgdsuOxbUxMF0kaWw1Z/s3x7kVanaNtuFmazjrFdFwqPScoNXar+6NgXeKn3nOgWSq+VG7AHRlYanmAJJ/NXremhBlqgAC1lKJ0FHEgtP6jw/91UVew/GEVzeyoS6grq9Ls+HPbFrykOtqBk7S62/q65RHe9xKoVlzjzoijM2i0Uy2lJ5JRLwenDIHeoOEzuqabj7njbw5mPDHRlsVAW+KFsaxaKtG
 SE5cvsd7
 XMfphFdlDQ4VmQcekVTY94MNLPSQWtGYichb+8td5bHX4ZAjsfSaF1I9Zk7irgwGID4iDX7YtZFptqs+eQsh1PNmabVAJmU2tFPKkLIupjNIoOqZGyuWdqUS5KqikuMKsvuyiNweUvFgWeCsgczXwEFkWHzoA5+ARKzL3RfUUmaBYzVRUfKbWxeWd0RBLg857Skxryva5mA3KVBDnN4whmB4/Y9drhiwt0ykxigBe4Eta3S7I1iG3HbQpDak1UGQvpNv+MduAUDzwgNwBpLk5P5Tg0yIfz2NuPW6seKmPk1pNw1Qn/FuKgBcvz/Vk91/tdzItqzqAVAhMNyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 03:02:48PM -0700, Borislav Petkov wrote:
> On Fri, Oct 02, 2026 at 04:55:39PM +0200, Nikola Ciprich wrote:
> > I'll leave it running for few hours, and report back. If I'm able to reproduce,
> > I'll try recommended workarounds and report as well.
> 
> I'll venture a guess here and say that Matt's reproducer won't trigger on your
> machines.

and you're right :(

> 
> Just to rule out any other issues which got fixed in the meantime, can you try
> mainline Linux and see if you can reproduce your observation with it?
that'll be very complicated in production.. it'd help a lot if we could reproduce
it in lab again..

I guess we'll add more windows guests and more load in them and see if we can reproduce
it in lab..

> 
> If so, you could share your crash core along with debug kernels yadda yadda so
> that I can poke at it.
> 
> And before you do, make sure you have the latest BIOS and microcode installed on
> that machine.
> 
> Also, where can I find full dmesg and /proc/cpuinfo from those machines which
> trigger this?

I'll gather it all and put it on storage to download tomorrow.

cheers

nik


> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz


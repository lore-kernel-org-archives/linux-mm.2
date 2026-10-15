Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FAF0CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 09:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720C36B0088; Thu, 15 Oct 2026 05:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2216B008A; Thu, 15 Oct 2026 05:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF996B0095; Thu, 15 Oct 2026 05:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3910B6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:14:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8B07804D6
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:14:44 +0000 (UTC)
X-FDA: 85324300488.27.8BA7C21
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf31.hostedemail.com (Postfix) with ESMTP id 40D6920002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:14:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=SbjwgFlr;
	spf=pass (imf31.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792055682;
	b=QOnBNCRWoEKe7tHZfPDTeKajSaq98Y/E9W9DFbckcJ+C944DmeRQ8DBXAkX9fyMRQLSP1Y
	r8eTuDMXglMIQ+fJB7iYQa2jLddfBlB1QBxaea3YfLu96Y6sPCLPNQ8hXu4fbMCsQVE1mV
	Zqfjzfktk/4zNrB9+VKRVk2HaS+eUBA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=SbjwgFlr;
	spf=pass (imf31.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792055682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=McdUAvh5NY74wejVvsrsL2dv3zhZUPLBMc+Rqofd0fU=;
	b=KGhWRP2/j6rvcZTcqKG1M3kTiE1nhGXAPCTmznvryWd3gSb07q+v3RYUAxAm3jT2QBASSO
	/eJfPNxndwoEUJ1ASY1uiDDTb6uUic2IqEQlkmN3JA9vJ38I+HNYW6Kg/IM9kUZVKYe4Z+
	FDwO+iMVZ1Ake1mWCN13i0xr3piPGFE=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 69F9ETpt679695
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 15 Oct 2026 11:14:30 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 69F9ETpt679695
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1792055671;
	bh=McdUAvh5NY74wejVvsrsL2dv3zhZUPLBMc+Rqofd0fU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SbjwgFlrB/HFvPgvt1Z37zZvYBJutnz5+Cj3SJVpRUyznUx+JPtLoUA6cbc87dFJM
	 FRIl8p9AAB0st1WbEzg1xi6ENWl3FjaSnkGi1QPDIZKET+cyrrKkkS72KxZY4KHLPN
	 dKOVbcM7xvb2wuabcn7zWrys9/gyikLO23YXMvpA=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 69F9ET7c003597
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 15 Oct 2026 11:14:29 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 69F9ERRU2934612
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 11:14:29 +0200
Date: Thu, 15 Oct 2026 11:14:27 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: David Laight <david.laight.linux@gmail.com>,
        Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        david@kernel.org, Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Tal Zussman <tz2294@columbia.edu>,
        Matt Fleming <matt@readmodwrite.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <atCZc+XB1eWWR02x@pcnci.linuxbox.cz>
References: <asAE3kLFDUx5v0Nw@gremlin>
 <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
 <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
 <20261005132113.43548696@pumpkin>
 <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
 <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
 <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
 <20261009090042.39ba9c06@pumpkin>
 <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
 <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40D6920002
X-Rspam-User: 
X-Stat-Signature: nky4j4qj8n61uqbzte6tft1c1ugwzeor
X-HE-Tag: 1792055682-253288
X-HE-Meta: U2FsdGVkX18VL4x5sTgL50B48APH/lr/UKdQVe/PusptS3TGnqEJthaXykDxxAUblk/Pva5T/cjQxRRcBmWpO785DU7u/74FjFrOoGh/S8aqIzuOug60F6hcLbYFP7pQMziJc6B5EAs78ec6smEPHtPiLxx1T/A05QUTbq6XDwgUT87f5VDFcpZN4azbINsRLLf/caulUmy1WB1VFQ2AAZrLDeB3b+vcsWPl4al/vrMa0rqsh5J8zmR0KOLnPHIP0kygCO+Isl2cEulynbkKOMifz85s4P4SRq/DPKKMEoOhPLNu9EzLIsu3dcsvaIslxYzFDNXBYhn8D6nycoFul8Jg2Eaakegu8vHSnduWd6b1E/AAaPeuvvvrnS5PQvKMlMQz3hafA1x3Z5vYx+5yyA5OIC9O/vThqEplNDJcnrnrZO4K5BMfL/t8GaQ+2yfhojj2+bywVaDisYMQkGmtVANYmQnsguSGGtsP672ztyYCClgK1rAP7istYHWiu0oUaUvpTbkMSfssSsuktiSjgSyPNDKpPQLRGgZT8lyk9IWMYmDYp7PNrejBjGxTL2iki5QyeyHLqWZlYPoqMAATbKu873jkvRd98ebSKex7OMiZDhp7u24v7mOo03pl/MqywVhr/Hx/bBRG5vpmPxnSbmL+kDPM+VkYoCQNwcqE4fpiIVmlfOY0qq0486fftSXm7ouqloJXMnlGVQla1+dvNT2eN0Cp4tcGccqdUNlbMBoWfbHJKVI87nJdGSUkdNZkjbZNyg6zxGeaxqV44vsVSQkw6pd13odPHbv2pDXtXY/IUgBOcl1lAhYKv4LjuWjCY+tqERUHy71lAJd+pc6yfF/TUy1ptHlcKcVjMGXIzleOOzw8yyv7u99iFRgQ5iO1bVQAJudHjU7n1AGTE7Tlf1c8lwk29C467ARXopyRUMM8EK5Td1glzqCatXolPWIR7ubK1ammfmOCZz3qyEj
 BScbIIJ9
 6ZGBn7qXzGowyc5DaEmaI0G2hvYbcPxfBLXIGfH0UXAcMmDD7Oj161ts3Np65qg9r0AQRsFFxk3JO0bKN6VXxsr6WlCISg42z6juzPAPZ9RmhsPNmt+H1Ft4p5zmGPFQ0HEm0dxpeN5p5ilvmoXogD99COP47KXJaOUhib9d2Rjtt4oFjap/CqusyAnJl4ganZLElXXsLd9TxFaJOxD88ewVKaKgUwRQd/ReS2OLU+cy2R+9uyplTe3lb8CTnLFWlz33PyEWMD/74clRczw6uRttsXagcgmrBIM2frU5ctjelOwHiJ93yHwEVF9/pvRMBnbgT5Lie6qW8HTDbOUGcp8mZSQ23+3D1GPdJ1wlXMik1mwMIgCJTEYQPM8+e0s4b1VWyOiNQsDYmhTGPfE5THLVOCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Did it reproduce usually with this?
yes, we got most of the problems (crashes / corrupted libraries)
during / after VM migration, so it seems to be the best trigger
so far

> If not, keep hammering on it with the latest kernel. We might've fixed
> whatever that was, along the way. :-(
yup, it's still migrating, it's been another 3 days since upgrade to 7.3-rc7,
another 107 cycles (of ~160 VMs, some of them pretty large), still no problem.
it starts to look rock solid to me.

> 
> And if so, that would be a damn nasty bisection to figure out what fixed it...
> 
> So pls hammer on it as long as possible to see if it is really fixed or it is
> simply harder to repro.

it doesn't seem to affect users in any way, so I'll just keep it running
and report if I get some issue

BR

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


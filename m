Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6AF7CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 04:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3819A8E0038; Thu,  9 Oct 2025 00:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359548E0002; Thu,  9 Oct 2025 00:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295CA8E0038; Thu,  9 Oct 2025 00:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 184A08E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 00:37:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1CF11609DC
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:37:04 +0000 (UTC)
X-FDA: 83977315968.25.1467A57
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id F2A291C0004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:37:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 37jvnaAkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=37jvnaAkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759984623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=43Zf1ZyH9cln2BnLQLjK/Ww8CSXVGpBmlcxa8YPOnfI=;
	b=lzWnmVrs2/QaeZuevNuldvpQmgLYhAl4VJZBDv9PDfYG9GDD/xxPwmgcGZQVjGBrcgck+T
	UwKc0AcIprTQjEN/u5dxaX3ieqnUurgVNWbWo64cqaT8qly5t6YOYQbgWZmoXOujGa/bu5
	63kwknT9ZBgen7P7FvTCEj5BriSJOqM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 37jvnaAkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=37jvnaAkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759984623; a=rsa-sha256;
	cv=none;
	b=mpZmHbvV8A9RnMp7/4PVgJFdkQjBQgt2vOt/SXqKngUlMWO1La9uxxQ1b9IarWvItgMGRZ
	nV/4P3OaFqKI5zqDI542RCXn0ohOmnEPAtapEPHkKSG45oFbLRMZDToQRkk1+xvKBQzoGy
	cEQLD2whxV/MxE7a3JP9DqDyQiUUleY=
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-90c806bc886so109503739f.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 21:37:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759984622; x=1760589422;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=43Zf1ZyH9cln2BnLQLjK/Ww8CSXVGpBmlcxa8YPOnfI=;
        b=KTqBtOSRE/34uGc7uqjk/mBpsUOjOU0KH9/O6NuLKwXDFjPBgaER/ytlFQzmfY3Fvy
         JRm0RdypuUQ8An597Fy/FwgIIwmhc3tv6N6NhIIUBAuzhRpnUx0RNrhwTNvaaKMoAbeD
         iHJ5/Brfocn1/tkN6mlaaPivaS8FsX1R/XoX9ybuIabQ+EX1Efe5QDVD7IOgnmRCAioC
         rHaJHfmT8QlaOCmQKoNnVkl1leHlUo6Igghe4AauR2NFoCIpGM70WpunpDY9a7gh7bXo
         tl8kjRh1MkQbgff2IIg3fKv+ieX+yJ/eXF+Z468mvxT1TsGxoSwfv0qh9+xAvqL+VEFD
         LFEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmQow9eoIs9DS7eUei0MBe3QL3hRPPLL28AXEEK88lpazSOR3oTKOaq+dx1VuDzAY0lN7ecvdchw==@kvack.org
X-Gm-Message-State: AOJu0YwOu78FedQpSiDr7TnnQmT+69QjQoJARxOp2tkCPNRFGcrMl5ei
	n/hTbHE7/Yx0+RNl76R+jEHHR/v3zTsnWzB1vkyYe4Sh+lBZNOz/TUkgqRAiLivdfnHurzwbBPW
	WUrXLDhArmeHvB4bcwavGlL5eEBXd33+Ko/kjSoqWHANCbMA4hSaGJuFcFg0=
X-Google-Smtp-Source: AGHT+IGt6q+midDEfUZFIkUDMKnVssOlfxgCVejmzPI3mMpG3CFD5Wb1tQ9IL6hr2PME+yiTyEVwanNvqOaiwsze9RPLHH0X9L7J
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d8e:b0:93b:c4b2:2b46 with SMTP id
 ca18e2360f4ac-93bd19b966cmr639084839f.14.1759984622155; Wed, 08 Oct 2025
 21:37:02 -0700 (PDT)
Date: Wed, 08 Oct 2025 21:37:02 -0700
In-Reply-To: <6897b156.050a0220.51d73.0082.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e73bee.050a0220.256323.0174.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in try_to_migrate_one (3)
From: syzbot <syzbot+63859a31071a369082b1@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com, 
	dev.jain@arm.com, harry.yoo@oracle.com, hdanton@sina.com, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: oj98ics6ayc1ikppw56p8aik54of4wyz
X-Rspamd-Queue-Id: F2A291C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759984622-663433
X-HE-Meta: U2FsdGVkX1/GyNRJOxz+pMJMGwitmRP8kLCxA/xHsJyH0DafvFrhsyEVIhT7Ieu4wcastSMM3wiyo4I7/Pfo8EOJW584BybgczU+eoyxiG3jcVI3R0yadlEYpy5hUjOt2rF6hPYmTClXTj9M10BHRpF4jT+ze5m8HMNq5kTCQ6zl8kpkiW1xjk5E/deo2VQBfAGhuHQapcFfr9v30U3ay+Eer6cy8HynZVmH9zsG8HHJoy250ow7vYBahsH3WCY/jP9OL5QBIuZcC0IZHx/V/qGcWYZyPoo7gTzMswFrYlTvEcCR1tKIfwdAcc0ZlxDG29aRk/Rvue0e87m47ONYyx83iBobo4OSYuvwjRI6VLGcncNn5tT6NRq6KY/pu5o0TO/v62MumdvGQhm8nv9dxJBvdhEsI+WItqTXUxp2sbq+lo5A69Ku0j9xKQjMJHoub8stb4WfmR0G2TTF1VRTUsTbJHJjeINvA47YHnQvoMqgQPGWnFQsRO4PLL70U31XXWVxYQyJGGMDfLW+Fk+Upg2cS68ZJ4qK5JcO5VhEX2wtYCIR6XmjYaOFj1aom6B3qxodXvcyeyTC132AYaEonX4VIClqLs5euAV06dbS2IMZIFWA5d+HmMR8am9pmDNBHAIhBKhwr8M5w2tDvPxHU+lHSVK6uvf5f+M6E0N/IHjKpV3qpO9pdedhXwXU2KUPEs1ihBZ+SSEfVDeP3OTxCBx1W2rHrOYbNnt3zJkzIWKXeLzMS2AhOBO5LRLhC5t0vSs8kbScDhqIbBx1hcQckMfedVXnvb116cY2FAPzhABdvFaTl0DY91Dbs0D8x9Q/ZoNAGLpBu3/NaTtxkk2GEgnoJWAUlt6r79dePv7ON6L8f8M+gO9vd/JRhIjGT53lAc5PNhEaHuroqceS2Mn/8c5yPMEoU4s4kzhC4EKWVHXr3+FAZajuWymmNEcgsj/mkwZPnaa2ckhTiO6y9Dk
 HTO06Qyg
 N21ICVlziRLE3HSqLxugmHLa29w/HfXahlopuwRbG171f3uLVbrRQrhSif0CrLnYDGyo1VXFJeMeSkZVbWNZKgE3456KWp7jA2/LeBQJE8kRkZgQ1RujzcPLSeRzTZzujS2Ajas7knWDbudXxDu5gnegaGMAPt02JMhwc0Wsz7Lx6JdPj3HYErfkdtcnFhvQmtD0LliGNuT8tau3h6PQMuPseT4zyeYyWF0ex9iCVrw4kclgTlriN5SFTObHtEDSVkUYC9l6IP3IHEqaNKu1celYH6RwWZlirVlq+nYUM9H2fLGYdz2zgnY98abscpCPVYAcXAkkbH3olRy3l4vCtWYovQbLU0uUCfJHeWWdVF5iTSgAd5F7INKSt7G4CFQjpAckwsZ5NX/8EQ6AT5XFNsJU2CeUQZiCxsQacZk+Yi2IMOeggU9IfPYi7wc5ODUnN84KpNUakt80V6LeZ9uRE2kyS5Vf0N2KRszscoQ4h33NQ/JMd4jO61HZ4R6q5eXShHOfd+Z8GUb5daIpVQWXzrSPAEJJgT+s0+iwdlEAHffWzYmVXmeWpRvuSXW8EzqO2tP1ji13+fuZGLLCm7L6Rmc4Qh6nBKy0w9un9iCXFcbfqMZY3gCV4m3Ll03KMouw7CZLeEOYGOZAXoEi5XYuxPT+axLvApCsZzk5kollSUpVbz0O+lNYjR1gEBTIuNdRoDN8oarE+aHe9A2A+KCm/WUAl6Y2m0eghll0RSUg1YUXAtHeJJdFz7BLoggHIemD5xsANnXfbxDep95CbFTJZBgL+Qf3DUpTwyxH3zgz2CzU7mDea0GKrHR+c+Lm3FxpUmWcgnq9Y7LGY1UK94qDCuUh74lVh8xm7/4ZxGWFKN8l0KortpAdCrjAFoP8cqPyc4BpjR+AOIO90QCQhstnsweDcqlsSCSik4q4bHBP2FgZnuDE1sx94gJnywcWAxEeF7Nd+ujCSHTQfZKZseGx23tKKxTtm
 h138lYjM
 1OLNlZPAKppHuN8VOPhRzSlkkgconmki3IgIfcmkBIMxF87Ty6bmsT3ES0IAEZ9sX7YKT1aehofz5P8QNv0xdGMxgmo42tzZO6o4vN10V0jko9DpQrDEEylxYYb/jSx4JlvfdsY01DHyirkHxtR01/4YjAHWtkeEn4TZSeimX28PUTqI+iRaLDes0eod3sEWFj4gGgtGZa0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot suspects this issue was fixed by commit:

commit cf1b80dc31a1137b8b4568c138b453bf7453204a
Author: Dev Jain <dev.jain@arm.com>
Date:   Wed Aug 6 14:56:11 2025 +0000

    mm: pass page directly instead of using folio_page

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11f121e2580000
start commit:   0227b49b5027 Merge tag 'gpio-updates-for-v6.17-rc1-part2' ..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=2ae1da3a7f4a6ba4
dashboard link: https://syzkaller.appspot.com/bug?extid=63859a31071a369082b1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117c72f0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ab7ea2580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: mm: pass page directly instead of using folio_page

For information about bisection process see: https://goo.gl/tpsmEJ#bisection


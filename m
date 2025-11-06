Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA56ECCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 12:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5E58E0005; Thu,  6 Nov 2025 07:02:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DE08E0002; Thu,  6 Nov 2025 07:02:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3908E0005; Thu,  6 Nov 2025 07:02:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1E58E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 07:02:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 233C312C90A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 12:02:59 +0000 (UTC)
X-FDA: 84080046078.19.99404DB
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	by imf23.hostedemail.com (Postfix) with ESMTP id 217C7140009
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 12:02:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J5r5YDTX;
	spf=pass (imf23.hostedemail.com: domain of ankitkhushwaha.linux@gmail.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=ankitkhushwaha.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762430577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPtGSfOGi/keSSlURDQLQTcDjTM2nCUWyB1gbbtP/wo=;
	b=e5jwoBpDkarRHQg3oxppUwLv875n62MSJAaHRlwg6Fs4JUlWTtWcL2Ni+eTpVHxf4pQG8K
	WVeUDqvGaw6mSAf/jfPZp6Ao1wn5hk1JKmT/i/2Jc8he+ETb2LkKjrRo74vqlnqkxR+0Hx
	x4pnR1v7oLYH47a7aoIaw0FwBmOZ4HY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762430577; a=rsa-sha256;
	cv=none;
	b=4bGc8qOi93ToDydjgj4iiMvKJEgsIUi9HxkxI65ZLZcD4n7E7wQIfGIXbf0vcxwKnDQ5pA
	WxGcDEmQhIQxhBJUQDr3FOOKjRE+S7CsgqGYI8VJD9hWWlC/Z6jTIbPSgxgxqNtRduB6ue
	lYWLwrNO36AoHKb4CbhrJBOtz19IAno=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J5r5YDTX;
	spf=pass (imf23.hostedemail.com: domain of ankitkhushwaha.linux@gmail.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=ankitkhushwaha.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-295df6ad56cso8557315ad.3
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 04:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762430576; x=1763035376; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jPtGSfOGi/keSSlURDQLQTcDjTM2nCUWyB1gbbtP/wo=;
        b=J5r5YDTXBK6H+KWhko7NoLnHu2h/mGkrgXWo9efw1K/iulpEi2VEFJILReZkOhEJuz
         a0xCqGEF1k2TcoRq7m3xjcQTje0dGEaJ/sCr348fOGoQzDkgK1hWYW/DIBCS8p/lJ0rM
         q155cncFAdWdTGK5I1kUaDirJd4G+24j63amoJP4miasLWNxDkRJfINf/OIjbFbx/hmG
         SX86fqI8/tB3BR3C03uAoBbITEh0dg6wGrsnr/jRBd1HuqZ1vVysvZQ9l+Sa8UvTkW3o
         eWG6aipI603LkLqwq5sXjK+fcshb7ZNbr3UTSr41/WGnPN3CFRSKqyP7ndTSEEy9UWC3
         b1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762430576; x=1763035376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPtGSfOGi/keSSlURDQLQTcDjTM2nCUWyB1gbbtP/wo=;
        b=nVwZdDFWHjjqFoRx3pKbkRKHVfmNunin3zuDihQkOA6J6IvkcId5WD749oHC5mPHEi
         nwacYpzqKLPY3kH6wfanwL/g0FJtxI2mdL7kIfSo5sE1Tosf/vFsFcGnsNX+bP9xwriC
         XM4pqLsDAy0c8FvZX+gE8LolhlumMpXcKYR6NznC3vfhrr2iOTCLo8oqtgX8w3dj9dtI
         SJxpaXzIBP3jf/7voTnJBO/skERQzhalglBlnaA66TvUaiv2FNHaj2sRqiBUqClNkWG0
         75Fqjpwaly2/Bkfu9ddvMoiE8AQi+JiEYvujZ1kiif1AQDOCtsLslBbGl310ZoFJkh58
         uxIw==
X-Forwarded-Encrypted: i=1; AJvYcCWny5rZNmWDQ/31Grr2KwNOztuVdHQmGbFaJdZKOo5ABsc5AIAthjmNsHTr+skX1vz+sSm2zR9LdA==@kvack.org
X-Gm-Message-State: AOJu0YxAz8KmJMv+DdXyf5zuVb+exZZmBy1BJUDpJC7ARCHvtOZAYcA3
	Spzzutctg+dY5snAq9LNW0et580kTJ/yZfiUJkFlfAsp8+8zkrzrpRon
X-Gm-Gg: ASbGncvOMBZu177Zm3h2O3wrl79hGN+11ZSsUHB/9U8wxNmQasnu+lbAbu212AD+1KK
	QEoaeZPnmMouTBMy4tK4NIOzv1c3u6FBif0uH6/ogTJn4bZX10VxljMpZBz+JggEfMthIOGLcY7
	BRiMF0JFXDQZ10Nx75jRYREvrapRbGkVDRLSwYm+1kPNT8dH1Z0tYaHSPwlyTPJqHndktw65H7T
	EFgCkqs5RzDDBJh51jsJHLJ5jS1l6DbfYABJm2dHDVTCcFDGiA3IjGpenuckM/dqksLn6fkooW1
	AC2LXFudTWp+XwvPFhslATYUYi22V2xRyFL1PucJE4MHP0XpFdSHCgQBYdwPpMsZyhgJMENEeSP
	gayTP0F0y7u/cLcKRqKUCpYlYXSlhcTXez+zAC/wSdb5Saut+jTh72ngpCeH7tws5BAH7ro7piP
	Qcd+9YzD8uibFOo7gUQB3PpSgcVi3suQ==
X-Google-Smtp-Source: AGHT+IFg4ppP6vi/pJwmzK9YEs7d/wlWubuW638khXVc5Pb/3DX1F1asOgyJ4kSWyBkD8lMqiRUGDQ==
X-Received: by 2002:a17:903:287:b0:295:738f:73fe with SMTP id d9443c01a7336-2962ae4fc1emr78620125ad.30.1762430575766;
        Thu, 06 Nov 2025 04:02:55 -0800 (PST)
Received: from fedora ([103.120.31.122])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7af82afbb45sm2582114b3a.65.2025.11.06.04.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 04:02:55 -0800 (PST)
Date: Thu, 6 Nov 2025 17:32:47 +0530
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftest/mm: fix pointer comparison in mremap_test
Message-ID: <aQyOZ6eYng-IjxS_@fedora>
References: <20251106104917.39890-1-ankitkhushwaha.linux@gmail.com>
 <fc051006-5cb2-49e1-bb27-7839837439cd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc051006-5cb2-49e1-bb27-7839837439cd@kernel.org>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 217C7140009
X-Stat-Signature: gwdbb5a57ooc5pspapofp4xkfsrz549w
X-HE-Tag: 1762430576-525359
X-HE-Meta: U2FsdGVkX1/px8iWWQhMOt0dQms+Bt77SsFyt/HrRqZ1cZVX1vSdE1/2G+w4VEIEUkonmmjZXf6Wmu0Tt7mo8K4t8qCWV0exVAWiFVhQviSJQ0Yf/7f06XMHgfZKPF9hTOAbpP4tyo+8c4u9ZtFv3jKp4o5sKsiFKt5D4YYnuc9SESw95W/PTyW2K7ZI1A+2RYG9gS5nwIdqScwyug+ITd8Mu76m/oHpOzhvFan/+J2MBET4WhbtKO0Mb2x46tGz4ep+tTptha/M101GTGHnrWHwBWKIg4oBEPTMjNwdI9gTlx1yhBBTAVKDeUm8oiwN769j/mZMDuLn4bDzobWO+sxvnLZ/nD0BJ9d+HXVQZeX3D80sq1ARhVZtudSmox2qiRAqpRojtKZZ2Zzah4iX5oYG/FnGcqyOmu5e1jhxBqy1uWyQiejMOyfsx7pja3aJDl0z4/0B/gRyyynfiob3usn2UEDpVkH9aDiLBfHmoVshKAGUVEp+SebT8uuYO/9RjNFMQP5O3zIq1Ht4kZQXpdlTmXBeYA7wysg43hU6VV2gxuywrzk42Ojxe9okXm/gqFxLGjS2w+49GrLYOC81MOO2ATOncWEFQNe1DUX4cf1ONGbDG9a39pLenyMOp8DcPcCnhxMguIzzoVD5itjqfgmkR2YYLF3bjb0A8PDRa/Ob2T3FTxFlfCEl8f/eyK+E5/uEOzV1wemaw+kr4KVN5E9fFlYAUuME61oDc1YyE16IM4lQFeA5FZUz0Nbtcgr6h5UolJugwtfoDuMATSgNBvgNFs8nDdCdM2fcqxMfEuMiQUfQrQezVUW9JxrSQZKtmhmACqhZ1x5vuMbtP4db+q8Yyt8rEsrX8O9rH3ESgH7qX+6d5ay2/ek2nSBj7mocc5TdMQCjMxOMK4u93yWJRrge8HNiDVQFpPu+YqN+hs8OnXdm5MazqUfwnPddknSjLOmzEMDei9VqQfk7/BB
 WaZgsZQ6
 Z2NBPkCFv4wqoKzVRC2JKnk/9iDLjq9yO1Q3XAx9ozCwPrnR5EsXe06lepJZJ5qGXL4URYo/kEF1wHKqdu28rLDyY+VfjhIgNG8sUPCcX+If14Y7vVrxqT9rD70jQveDHK3WKYhssLhpbcXfp4h/Lzz2GLxSsrWQDuSzllKkdsQqzVYhh4s9bYzoRRFAzLV5vxUpVh/tbtMuJycOEF28jtSi0v7vEEIIYh686E3SPXN1B24mZiBgfHjECsWvWIp5L1McIi17VSvsO5s+Lay7P4S31BIzfFgjdl/HV3IwguUGVSrpwHOa+7UYtG8E5Jc/8/mJ+0Z97pVRGQYBVfJDR7naKd6GDymhkIpA40R0Y9ZtEM1tJy1DMmIyrH7mAGGOd75k69mge0KND0EGJQuTAKkyq5Xps+09fZkzzhAA6w9RUyvCoY4ISPRYAV6t6HvifNbUgOBiQNkBHDnQV25RFhgHWrWOKAH3P52hGgS7wd3T254Ew4g7S28gJp5u/VeB+V/7sEzDdbgwsPSSOFmoICuUz99gQt+ySy5eJrSL9IoQZGec9VBW6B8A6KFb4icrv+bVBaK8ew5tof28yFgyQ1JNZA18ZaAZpNtvvJCz163zuVwW6Sk7YkBUgnwiK9yBq+Dev
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 12:18:57PM +0100, David Hildenbrand (Red Hat) wrote:
> On 06.11.25 11:49, Ankit Khushwaha wrote:
> > Pointer arthemitic with 'void * addr' and 'unsigned long long dest_alignment'
> > triggers following warning:
> > 
> > mremap_test.c:1035:31: warning: pointer comparison always evaluates to
> > false [-Wtautological-compare]
> >   1035 |                 if (addr + c.dest_alignment < addr) {
> >        |                                             ^
> > 
> > typecasting 'addr' to 'unsigned long long' to fix pointer comparison.
> 
> With which compiler are you seeing this?

Hi David,

clang version 20.1.8 (Fedora 20.1.8-4.fc42) raised this warning.

To reproduce:
	make -C tools/testing/selftests/mm CC=clang

Thanks,
-- 
Ankit


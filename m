Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E4B5CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66316B009B; Thu, 11 Jun 2026 09:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3D7B6B009D; Thu, 11 Jun 2026 09:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B0F6B009E; Thu, 11 Jun 2026 09:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8951D6B009B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:22:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 500571A064F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:22:15 +0000 (UTC)
X-FDA: 84867695430.12.0B265BF
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8EE2E20003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:22:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3hLYqagkbAPMntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3hLYqagkbAPMntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781184133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=i84R0YalEnzYEwHeGRYpdEjQGHZvkMpM/hRBWXDcl24=;
	b=kYvB1Dn3vvEEC+C02VHIvwttOclFf41YGA2E0r42t3A7HzSKaAJ7h11aAwJKBY2EQtpt40
	fdgJB9dnST1tjH0Z5cfGwabkXwVZjfCush21MN6zxFElpka/IXfs7QCWlE6AXpJnbg8Wpj
	KKEJzy22nqW5gImpm29VNzp1XoYW5vM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3hLYqagkbAPMntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3hLYqagkbAPMntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781184133;
	b=SEFRI2rPsrDerBPG0d651ZvRj58lGis0kf+Dmu1V/xIN9Jg2kvsgJuRx2vpEvtvY80BzDR
	4O0Osmi3MnCyL845Tb4S6S9/sqsNLoLpKWa1eVdxFBt98GJ/eBZ6f719f1rhy5A2DX7QjA
	XDixA6RJdj0wjPPqUmWhXKZs1AsnQBQ=
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-69dac65fd9bso7336635eaf.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781184132; x=1781788932;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i84R0YalEnzYEwHeGRYpdEjQGHZvkMpM/hRBWXDcl24=;
        b=Y+i5eekhTcVG5tQhm0XHGCfVsS83/ViO8M0iu64DW3TIO3qnvqy+xd308Oc6QwkI0t
         IdErijpTcUOtJyghMLt5tPQ4SbgWSp3Av8aznr+1M+APYjV3k8vP1PDrMs6Bfa99iwkK
         l7vt4y1yAZ/9BpO4m+VE9o+DnvVnA9PYfVKgvcfRZ975h9F1tfSKBc6AtyuOHMcbcSSr
         o8ZdgzNwXx6KTA/r+S4JM+UYZaGASZ8DsoyEtRALNa1qGOg0yM6w6I+Bz/sEcWu28h08
         MuGtBIPbtckKoyh7VhLsPPKt0g64GlfqYId92FYtBDx56wyO1DT4B//kUfYhsdIc18Sy
         EIAQ==
X-Forwarded-Encrypted: i=1; AFNElJ+k+AXTdzBYkBDdBRyhJcxr4WDdF27l2PuLYA0y+icVPMMYpd6wameDoWuPBpU+lrT1feaX46LlMg==@kvack.org
X-Gm-Message-State: AOJu0Yy6J4JXzPk7V22Sm5Fk5IiItz4L20hKyc61qF0/8pyA4AJ88xnA
	vlaF4UyJ6UYndoF2hthD3Rg+HlzcWpHyEW+QmkxEhjmfzfYOfonoa5YMVqdYDNjtfi3gz3ttI6p
	tM45U3NjjZQn1z1QpCcP9RiQxYIOuJ3nT7LndqRKDxJMth2alRemaLHe+ZTk=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:824:b0:69e:3563:4424 with SMTP id
 006d021491bc7-69ecae66c19mr1786786eaf.24.1781184132771; Thu, 11 Jun 2026
 06:22:12 -0700 (PDT)
Date: Thu, 11 Jun 2026 06:22:12 -0700
In-Reply-To: <aiqjnj613Ut2bK1n@localhost.localdomain>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a2ab684.3b0a2d4e.8c8d1.0011.GAE@google.com>
Subject: [syzbot ci] Re: Implement a new generic pagewalk API
From: syzbot ci <syzbot+cie2febc77f154bb22@syzkaller.appspotmail.com>
To: osalvador@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	david@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev, 
	osalvador@suse.de, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3djcmutwi6p7ct13y4x14i3aeybhsfck
X-Rspamd-Queue-Id: 8EE2E20003
X-HE-Tag: 1781184133-324486
X-HE-Meta: U2FsdGVkX1+TAHWOedrw3MfR4USCwPf06svkyt5nw2M4WaSJFaNe/4OZHgJQzvH6FLNBsCRS7HOwiaXg/GMasC8dHWcJqJtGjybzarVSOga8CWBiJb8C9iTknm8ufAsi64wli1olPEbz4B1nW2/IWIvpbYLACSFnsd6i3J0t/xXoWHNPEEdaqYMDmvE0EHdPsSm+1ZJHfRCDU9Qc9HejR5Wfwow/g4ShVXyduwxtKcNQ0yUw416EA4VBg2dv6zKxT2K/Mzl0T9hf5o1rRorn3G8KWTkXLPosVH5Js+ehjGcd8kOo4PujYuJtozliErNHkI9S+HUzDEga5wARGqfsZs1r3KskZ9Zx3s+zw3XG//afNKRtoxbEInfS+T4eXU//BuVjn8XvBzsAMmFhxV4QDrpEpGrEm2B5GoUnwQSRE5nvfpTtsI1oaenQbFtXxp7lF9hh6CyX5E8DLCv9KsI77icMbgeoQjv6dO8BkAI699oGvfpjY582fhKvnDlqc111dMiAUU83YLwV+iApjEWRMc7AgIRSya0R271DOXSh1RqJHKOtxlzKs5m70nsMjViVmfCer+2ohK7MBKJI/a8sHs6o1mjnW21qDh2VN5DiIeh9rj8ex/C0YeJhTprpzlokRG1e//01/8Xz3nrE0fq4NXSCJ/rsIM90u/BJ40KMzTQG6CS2vsIPQiWgSv6cj7ERbQx/8jD1UCES68VMV37mFEiPHPMAzITcMhDV4lPK8ixY4BX/Uc48z0Jd141bh54vtsDc7Hj61fd7xOYzI+eOIHLw2maG4QYJr+2j65lHUb5yMx81/nDcOFvkl54VCqOK0W0cs+Ory/EVBuVxov98o7O7Ey9Wvd2S6X8VZpmHpysKAdlKsAX9YkSLb77z6dIbuuwETTuoCBeyc/68vNs01i6u3zM9Q+DPjtNCGPuLY1cLE/Kf3Atts6A/E+/xHakeCNHDPnb1g8ReusuLwhF
 sYa6OPKe
 FQOQHoTeHc+FfYNpCzMypFXGj2xe28W+wvQRBMBfKuQVy5DJjbuU01q6IirFc73eaVeZQHDReZyjN3KbGxjDpZetE+OH6YXVj2Hk5hTelFxtGUMajBO1RqkHhPHvmYld7/fPKj0qdFLK7064tXxhq1jajveMpKzKWrLMB1+zR1s65sBURWPptdXTlW7+1CXi9EjZCKiBTtAc98VVzyWQbOKYZqPbrf5/87ClZlW7TttV00tI6liFIes9OMkTvFtuat8rIik0b9PJ0zq4rRYaGu2lIXR5fSr2N6VWAB5Hn6dzI2jHa8CHTClvIH3EDrSScH7Lciz0XsaGj33r/8+C2ecgcIZE02BSK+jkpOuInMHwAr78g83toShvBGHsGbCZCNFLaKlhzvYfPiJnjhb1XDFo65Vw9rRut+0p+QnfLwQdK5AFqB18HDT/mQFfEx9sLfCoaBrPsW+NrLba704YtIr4iDC5TrbGKfMRxDK7TstF7UBoJONWAseGg8SF+DJuhoHBTERakHRl/6c3gbTLP/qfcM1lnX4dxJ9ZE+u9eX+w1ljgGYhL9qeSnCTH9q+WqcB7kqnnr1cTQ5d7oSZXmH3OM/dnkWrOKjg+pBzoOECI1mgIiaHbHVkAG6Yg4jrJ0LinQf5ZNaYp+aBnHhXTtwSo7Af+Tplet3RarMBzcC7im6i/poj3dDIZ70DHPkqFSRgFyVgys0TjjK/0OeqKheJBN7DAesfrIxdJoXtJpnHX+pOyJRvnrh5nDFlmeoGlApkl8SrZzvNcGK/sXqxzDgKK1pJmDHgG4O5KcbfQuS/MLlVq6M5wbNfBsseYyORI1LaUNboNakq0UtvgUoYEUYhBIzHRYXtaX5QDN2tK3+vv1VW2Y6XC+hcyk2hIBeLhJjAJDVY+rU7HF+4FPoWMD0IQ+HZaRNtfTAsRsonJYg9PwevaCj6PXkVqFBiSnOQqxMLtYyg5teGWWW30DzUzd6GrRSgsT
 4If9q4RP
 ZC026fVbFTFZYHATSKs+3yzP6RS9S4GObgp2JrnL4MHSqokqffRoPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the suggested fix patch on top of the following series:

[v3] Implement a new generic pagewalk API
https://lore.kernel.org/all/20260525165528.184397-1-osalvador@suse.de

Patch: https://ci.syzbot.org/jobs/ef5ed4ec-3733-48d9-af67-b53dff1c8b20/patch
Testing results:
* [build 0] Build Patched: failed

The following issues were found:
* kernel build error

Full report is available here:
https://ci.syzbot.org/session/90e7add4-2247-4f1b-9ca6-89dc339fdf98

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f29ebb48-eb43-476c-8d44-aa077ea8eca3/config

fs/proc/task_mmu.c:1713:26: error: expected ';' after expression

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.


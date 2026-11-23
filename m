Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D60606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ONd1LIr4
Received: by kanga.kvack.org (Postfix)
	id 5321F6B05B0; Mon, 23 Nov 2026 18:46:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A8A6B05B1; Mon, 23 Nov 2026 18:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8506B05CF; Mon, 23 Nov 2026 18:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1C26B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:46:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 274C880A39
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:46:19 +0000 (UTC)
X-FDA: 85468020078.29.9F0DC94
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	by imf26.hostedemail.com (Postfix) with ESMTP id C4F0B14000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:46:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=ONd1LIr4;
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf26.hostedemail.com: domain of jerrin.shaji-george@broadcom.com designates 209.85.216.98 as permitted sender) smtp.mailfrom=jerrin.shaji-george@broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477577;
	b=cMYnHv++6YVDeDmrRlDOTTwDIRkGl+eHTGVquVjY1A/CbY3zPTE6O0aiL52k2++MkkpDg3
	ITOSXYsP9UE7HbgP2+Qr3TSL/tm3uwCvuDadrfa7I1g1iznq/SkjDH7njuAimJsFjI1sGH
	1zocDHKzCXXefVqOh6UpFhUZrC4A+AQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lD5yBClNN+VymwvtGLoS6TtLHPECYALK6M/5xDhEAk=;
	b=nNjYvzikajFhbzfQNVBB8EQvd4hwT8XO77nUAKIChQaWnOmIi4DYE3bOnNzia1KxPZuDob
	RO4Q637lYVldQuiJEqCni3Wy9F/WyrmB+7yQIfDYOwk9rmdhBM03b4FAOpYRa9sJWKjMsq
	qUP2hfGVlX6CXTMyuGeHAj0pA7+U6qk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=ONd1LIr4;
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf26.hostedemail.com: domain of jerrin.shaji-george@broadcom.com designates 209.85.216.98 as permitted sender) smtp.mailfrom=jerrin.shaji-george@broadcom.com
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3b4cd193b50so152681a91.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:46:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477575; x=1796082375;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6lD5yBClNN+VymwvtGLoS6TtLHPECYALK6M/5xDhEAk=;
        b=qhNkA6gT+4fWVZASUGJUqeSCsSpVLjBXXWEdFsRx0tEKYKEwHCdu4XnwhMSFPGg7pm
         v5o2MnXhe6XHBEqS2WXsdAFAYXxJpmLRaJWzTFL7u4S8hQHUnVNxZZ+ed3lo/9/4QDaO
         rTJjz1FDrde3tW52dG2rt2kTizvw4LkgvhbWj/RJQaifc/iaAAUYWiGzga25vRJ5p5ZN
         P059grgMPc7ZsU2nhtW/U3ljlg2IsSJsk5+mLtkBr3nGHsG500ZGjbOBWTK/vAPyuQip
         tBt+8fWLypx1zfrypxjG5Xf1mQFw9hRKVtVaa6S1UQ1UjJBTiO8tTDDGmegyxbHbdp7L
         r89w==
X-Forwarded-Encrypted: i=1; AL+hErGVdztqucc/9kci+KDpRFGkc8aDb+LFhKki2jQRf2hDgw63MRr2pljJCCm9OoKRFeDsrUYcJHjqlA==@kvack.org
X-Gm-Message-State: APuU4Z+rcKI1j+ElOi6kQqr1zreinwvmRgHmfOZGhJ2VB5y5bVpNiWi8
	Yn9Ok9N013E/kgr9fbrr9ZkUERhoJ/q2qpig5jhqOXUTF3wdIjGuyFKu7xbufvG/R9RA7ER8Grg
	aQU/6LK3fwjCi25TkzFH2VXz/9TbkCgcbp0KWJNcDCO+EW21xhjMONgDza1j8UXdndLu6UeDh8e
	TUnZtgvt+seLHJcP9G3jUfTGpT67o5OCjE3gtrlaZxwjheVeLR8H1p/g9jPnuV8UjqKuh+MsUxm
	mRrFuZOuXfXINo=
X-Gm-Gg: AZFdTZebrAlxVYsP3voZrsQI+qc380lwJSTxUkjTkDdfRdEvHxP7xXWPKEpIrJ4KZC1
	vGEvHgpFhqOKF2tbFOhPVjE2vPrABMdiXfm3SI7E1Tjmk+yrwL0nKcSDHwCnRF+/qiERXAB84om
	DR5M4D0KYLUQTguGrz+zLokMWCkltYJW4CpRP9uSDllxmYtp04XUMiKQ7GSb+GTsNCgU3c4JU5P
	O3EtU82yc8x4t/nSU/Xe4RYfjS/Sw9gKb4mUKKZOQap+kr6VFR1vcYIjo+ZVu3wYWbjtC4kU9I2
	koC8Ydn7yhpN25dQRIQ/luLfYym1zEPNq0wH+54LiA+8O6d6we30DDDYY+LiV06ZjvKaavM3Ywd
	Rk5g6iw2P1Q2RJ+aAEk9H9mYbkmgkg0nd6s2fnfG4zJxrpaKPPfsj34V3y8Xp6k91zVl8OGcFyu
	rJjsRBYiulRRW+pWfEx31K73Ys9m8pnqRuwXJinFbKpZPZU0Q=
X-Received: by 2002:a17:90b:55c5:b0:3b4:5b2c:2959 with SMTP id 98e67ed59e1d1-3b45b2c29b9mr7384276a91.63.1795477575196;
        Mon, 23 Nov 2026 15:46:15 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-100.dlp.protect.broadcom.com. [144.49.247.100])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b40625d66bsm10068405a91.4.2026.11.23.15.46.14
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Nov 2026 15:46:15 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-9806756ea40so2480298241.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795477574; x=1796082374; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6lD5yBClNN+VymwvtGLoS6TtLHPECYALK6M/5xDhEAk=;
        b=ONd1LIr4ejeM4QcafGLbNhE91kFgzsyUOGmTTV8BEPPLndwhCActLs98cxBk9MOtJd
         v4Wkr3LN2rbee64DgzPTQ3QQL9YiiJiGzxBsmqz3ChFC/yb8AQ6H1CSdaUxbB3qSO1ey
         qnzIc4GO4QCs0TW2i+wv+LS37z1ZkjROhWDsU=
X-Forwarded-Encrypted: i=1; AL+hErERJ0aQJLYuTu/7UT6Sf1i5vBQBYsoiNO605sLqiVQM9QgPfOwF/2ufKABE5q+V7LFOs02IY+gaXQ==@kvack.org
X-Received: by 2002:a05:6102:1610:b0:7d2:8dd0:2eb with SMTP id ada2fe7eead31-7d7393ff1d8mr5969333137.8.1795477574042;
        Mon, 23 Nov 2026 15:46:14 -0800 (PST)
X-Received: by 2002:a05:6102:1610:b0:7d2:8dd0:2eb with SMTP id
 ada2fe7eead31-7d7393ff1d8mr5969322137.8.1795477573649; Mon, 23 Nov 2026
 15:46:13 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120-b4-balloon_nr_pages-v1-0-d8944b587819@kernel.org> <20261120-b4-balloon_nr_pages-v1-2-d8944b587819@kernel.org>
In-Reply-To: <20261120-b4-balloon_nr_pages-v1-2-d8944b587819@kernel.org>
From: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Date: Mon, 23 Nov 2026 15:45:47 -0800
X-Gm-Features: Aa3M54o9To1m2Mt4frhSqoy_chjBpgWQHpG9-FBy-A8uiNdhJvZ87Cw0sfMLCGk
Message-ID: <CACKNADXLUOdqtJLWdqy1OPEeEmj+XnPk8usqRHcssOYjt+8yeg@mail.gmail.com>
Subject: Re: [PATCH 2/2] vmw_balloon: account 2 MiB pages in NR_BALLOON_PAGES
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nico Pache <nico.pache@linux.dev>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000003e5020660fa33ab"
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: C4F0B14000B
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wm5qu5b1zxptgwfd5sfz6ncnm7sacnnd
X-HE-Tag: 1795477576-621817
X-HE-Meta: U2FsdGVkX1/NTUokeXeA3F2FNLWYyrYqlfs+++RhzdBF5RaV+S8KZKsc/5zkbgAki0D6gqYWWBoNL/hWVxl09zBB6kKvWDsX4NzPmjLa3mFZjWp68uZTauJ5JmyMrc5AcaKK6KNsY2b8pN4YHNTekTtnPkvCURGiX9EDfLR3gPWUPx/MTQPUBiyWdq0l37nHyAVAkTYv0RmfIM90M6wtWtj5CsL4InlTk0HYovWAXv9zSe6os+Lwnm8ex+0PU4EYtB6LOYUQJulE0ZMfsS1PtbLBMuTlOH5UTCsrrhC4rG1dvUSoImexrj+BtAGiwe+fVdsy5cB8pdxt2Lq99O35fHiCUgh8uGYR7PApANhua404TXyxW679lwPgUPGiv7QGcnO4CS16mR1OEsPsLQA1uUTuOHSSkXaowOkU+YI9oKyAK0zKqoIbfzsZpggs7roJRB4Wetk6Osla4MMl+ldNEbLTn14G9Y9cmUhzdeNWx11KR7xaTkGmZhgfaUTMbLaImYbg6hTrutcpb4hDwO45D3H+NRan/tgeHzlFgL1Y+ghyCDCUi6BkIgLntL3mUpMyyluSB+iIIkVfGoVnacDJpeMyf4DxbUAmwgOebwz8HufDkTIwEDoq8mn+LFf/17mV0ObepVlQlGS0auJ/dLrVgUhWlgTQUPMjfcX5bxIJIiNr/3WTivDZEJ76pY/6ruTUniEXaqfD9Q6jIOp3HJgSANe6zUj4lX/6JBEPj5VKd47MbkWIAWG/Zs0NJ1vkNyTvh4f+Wl7UkRHoDXDGxznmhaSa/PMZT+fd2BDDImckFYIGdqpagGM7eKypAivF5oVJgHCCz09bShAPAphi9ARjfc0GH5Dcxev40IWWlnbcB8bUlyldBcnfnhg4hpcgBV4p9il7sAYbZc0PAlPH05zOOYwSAQ4+aKo+jDLF27PI1EB4ouwzL4+YwDA1esIRH7US3u99c3veyLRAZYGzvyQ
 7g/V4eb/
 N8M8FnhFacxRABc0k9oSoXpik9bOhYw83PhDj8PS/DOyra26Qmc8ZurK4eCVSRfRloTJ3YgYY3QNC8G/n+/xCTJBW/YeuauEx08qYvMw+TMhW8hyS7QSaS7ajQ/knAiZwAMRLUrOAO9lPKQntNtpoJYTrHdxeEcH7SVm/dBz+xqIa8ltLe3nd/i8a679gZ3ufBkzzep6EKn4uStNf9ey5hOdre6iG77tv4U4N5GASgNwdP+ILvDGyl55hjdYap1O1ib6z3BVmLHlrmq4Ii7UOadNSVvHNrr9Y1fMhGV7iVKF98Epv7k8ccg/b9iZ3uoAvIAP7a66ErxIBsHzmL3G+otfiseb5k1vLB0d/p4CsGLnOgo5H5/lmyuuzqOplJBXCk74r48xbRq7+8PqXg+X99gdXUtsSoPcWObBoDkrPzsrN+maQp5WCrS9V0QoXitMtGxr6Ig7Shl4yHGOtB59FUU4FLUQBFxlPO9evkV0jKxhysNN0ABLQJf3Clo5rDg1TiBLWXSHg042FPCYQhJ4PrnjAv/Uq2AFzV+q8Wpg7n+Gcv6pDUvHx1YdSOvQ5wVoeVHnsPcm5nSay08p7S9kXUuBQ/f2+kUaHzcTpKUcbGPm0kvbUycKO9aALWLIBwBb9npNeZll8n5MKeVCVW4OYMtvIYBS/KILqXvOFPlA/EZ24wcSUBRCL0m1OpWRA56Vp+/ETvuynvYqLD9jdk1QudIYieiAUCpmfc1MR5mQvLOQW0/dxqTl8A3JWcgvujTy4nmBLPP02EciBLoiSlxHzdvfPFEWgWJ0W4p4el/0IyKnXqOrKdVIBsT0XBLbK+PvLleksYhDEVi7Wonc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--00000000000003e5020660fa33ab
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 2:34=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> vmw_balloon keeps 2 MiB balloon-inflated pages on its own list, not
> using balloon core that takes otherwise care of updating NR_BALLOON_PAGES
> for base pages.
>
> So far we didn't account 2 MiB pages under the "Balloon" counters, so
> /proc/meminfo etc. would not reflect them.
>
> Fix it by updating NR_BALLOON_PAGES when enqueuing and dequeuing for
> these pages manually.
>
> This has low urgency.
>
> Fixes: 4d689474e1b2 ("balloon_compaction: update the NR_BALLOON_PAGES sta=
te")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  drivers/misc/vmw_balloon.c | 4 ++++
>  1 file changed, 4 insertions(+)

Acked-by: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>

--00000000000003e5020660fa33ab
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
tJVewHuOmXgWQxNWV7Oiszu1d9xAcqyj65s1PrEIIaHnxEM3eTK+teecLEy8QymZjjDTrCHg4x36
2AczdlQAIiq5TSAucGja5VP8g1zTnfL/RAxEZvLS471GABptArolXY2hMVHdVEYcTduZlu8aHARc
phXveOB5/l3bPqpMVf2aFalv4ab733Aw6cPuQkbtwpMFifp9Y3s/0HGBfADomK4OeDTDJfuvCp8g
a907E48SjOJBGkh6c6B3ace2XH+CyB7+WBsoK6hsrV5twAXSe7frgP4lN/4Cm2isQl3D7vXM3PBQ
ddI2aZzmewTfbgZptt4KCUhZh+t7FGB6ZKppQ++Rx0zsGN1s71MtjJnhXvJyPs9UyL1n7KQPTEX/
07kwIwdMjxC/hpbZmVq0mVccpMy7FYlTuiwFD+TEnhmxGDTVTJ267fcfrySVBHioA7vugeXaX3yL
SqGQdCWnsz5LyCxWvcfI7zjiXJLwefechLp0LWEBIH5+0fJPB1lfiy1DUutGDJTh9WZHeXfVVFsf
rSQ3y0VaTqBESMjYsJnFFYQJ9tZJScBluOYacW6gqPGC6EU+bNYC1wpngwVayaQQMIIGczCCBFug
AwIBAgIMP8k3oYr9dy0fawOFMA0GCSqGSIb3DQEBCwUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAy
MDIzMB4XDTI0MTEyODA2NDc1N1oXDTI2MTEyOTA2NDc1N1owgbcxCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpDYWxpZm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEZMBcGA1UEYRMQTlRSVVMrREUtNjYx
MDExNzEWMBQGA1UEChMNQlJPQURDT00gSU5DLjEcMBoGA1UEAxMTSmVycmluIFNoYWppIEdlb3Jn
ZTEvMC0GCSqGSIb3DQEJARYgamVycmluLnNoYWppLWdlb3JnZUBicm9hZGNvbS5jb20wggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC97H4mZ7IND/iMuoaowZaUcFWQmAEUROR90vJqkzU3
4ljaKHGMed2anb74NFJ+ij38btvWCdWlqUCs4umStciFyeOshWgBWlZO3bpE9BkonLzG9DGwSz5v
Ve2coDRxUIjXbcXgys1z+HiIaZVEBEtpGgBz/Y6KeJr6HHOLq3+1VA6HZ887DMaJ0BygdtOm/g/o
6d185nbusa6X1Si3WqQQEGq9/dHdVg/ScOBl4Hu/sEyY5dYEtIS6+wJOfeWq7PnJwK/ebKrmDXRl
CPyPFwCghdN64vwTIJ+z21krDj9mv3w4e/ow2NiOI82oVpFYCmR7NQAYn+zR+9ZMebTTtUR/AgMB
AAGjggHhMIIB3TAOBgNVHQ8BAf8EBAMCBaAwgZMGCCsGAQUFBwEBBIGGMIGDMEYGCCsGAQUFBzAC
hjpodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3I2c21pbWVjYTIwMjMu
Y3J0MDkGCCsGAQUFBzABhi1odHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3I2c21pbWVj
YTIwMjMwZQYDVR0gBF4wXDAJBgdngQwBBQMBMAsGCSsGAQQBoDIBKDBCBgorBgEEAaAyCgMCMDQw
MgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1Ud
EwQCMAAwQQYDVR0fBDowODA2oDSgMoYwaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3I2
c21pbWVjYTIwMjMuY3JsMCsGA1UdEQQkMCKBIGplcnJpbi5zaGFqaS1nZW9yZ2VAYnJvYWRjb20u
Y29tMBMGA1UdJQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFAApNp5ceroPry1QLdugI4UYsKCS
MB0GA1UdDgQWBBRPHRKFeJNRjFAKjHRo2iVVbhmbHzANBgkqhkiG9w0BAQsFAAOCAgEAZ1qrS6Fb
dv9hzcer2Yv+uU29P/iOOBMMIkRHYE2il+wClTPJMmcqRAmTu8S2az2h8XpMkKoWDTHwcj2KUfaQ
UlkMc5m9wMxAVDrklB1uE25jWKnE2X3NQn62oxIMbATya2F6ev8p59kLh2xo0GVxotVnapnbuAaH
2D6xevthNq3e2akPKltISCI38CVOcC7rWuBZrLgdR8dEDLyZW6UMPwJLk7v4ZPyn8E5pMKc0fI5V
ZaWzs68PnkVmKNbpx1cECaQjsrBrXo/HNOQ/DGhHXNIF2k71laGetuCwhewrSdiLQZ3g+oAAvfKU
/FZV1kxiUVet5SmPA02BCW5yz80uHPemLT8KW8un9H15UXd+axLYqKEgr0nzl9stxbsC3vC4pbXQ
688Xqj7ZDCj3LGVbFWcdQ6bPAcxDwLm2z6A7PJdV4xDPTYhsK4io5/ZfaHOC8DqKT3klVZIo+Heg
5NMaydZ2ZiuKonE1AwMVn0KLV7r+vs/l8mIxwHLrNuWu501u2FYtMLcau6ZT0KbjwCKmMVqpvqMk
Wybe9jF+aZWzjNutxjSJGP5oSmrUpNP3UzAio93FKeLiweQ6L7E6GTBIrWNKHEog46OpVY865QPD
v1r5jLUYELDXa/NsznnUxWljMsYK9Qa4a9MUkQn+FF0b1xE5XuFm3mncJgGAsbZeN8kxggJXMIIC
UwIBATBiMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQD
Ex9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAyMDIzAgw/yTehiv13LR9rA4UwDQYJYIZIAWUD
BAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIHHwhlLmK+lPSjnvL0KJHTVkI4kBzkdH2IHR6pHEdN9L
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MTEyMzIzNDYxNFow
XAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAK
BggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJXc
BfmrWXFo69xOCkcKAonrEpIu5YNuIdsEaxRC5r7BR21kWFGz6i7JUyYx5bfAjtjl8OfdVzh9kxMH
kBw2aGvpq2DZgbbXRDf1A2JoH07VhvbtaWnsCxpoM9vGreNMdwJZQvgieBUAfrFjwVH5XrFkK3UZ
UXn8TNNq/xPBDvrNRVUvq44ZS5LDXikxAs5LZwtb9Pyo2vve6N0Glo+UuPlH46UaFKTXxQ/m8XWP
Hyi4L0pE3AfjHT1r6uA++/IjuklgTR8WwKFp40O7USavYut9YyFI/DKwdFMTaHIPAMgtq8GCCM+v
+lRG/dDMsLbHxK8FR1f9/VzdsLRaGZoIkUs=
--00000000000003e5020660fa33ab--


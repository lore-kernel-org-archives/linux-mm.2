Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2510D606A32C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=cSGNuTn1
Received: by kanga.kvack.org (Postfix)
	id 1B8486B05B1; Mon,  2 Nov 2026 04:47:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169906B05B2; Mon,  2 Nov 2026 04:47:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0325A6B05BD; Mon,  2 Nov 2026 04:47:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB7226B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:47:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47DB4120C10
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:47:17 +0000 (UTC)
X-FDA: 85389700914.04.86019B3
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id B1CC140005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:47:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=cSGNuTn1;
	spf=pass (imf07.hostedemail.com: domain of "prvs=97666edd39=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=97666edd39=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1793612834;
	b=Eb+4eFh6auXJh88db1e7Y/dHRIb6IBOjhfL4enkYBNGyG7pdXTslhMAk388xOUxUbbvrty
	1UWI+uhGOAZuCjGS/4RdGIWrOMTlUeN0FXqxoiJNmLPVBR6oyVEoFcjj/wu2XyYHf8uMtr
	4tZv/cwSMH5zQcNZa7VfuIFNmf0Hu0I=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=cSGNuTn1;
	spf=pass (imf07.hostedemail.com: domain of "prvs=97666edd39=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=97666edd39=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793612834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIisd8STYt04AoWykShpx5GEMDUc3yZT54lWYvDNDAU=;
	b=oXZ3SftAJR46rVcpQ1Bx56LZdYoVRn8FkCAXUORG7cw9baoZTlOoNFcziDNriTpPAWVGSR
	eE2s5eU09dRlh/lSh7ycE6YUozsF+BMoqf3og0y0sgEPm3AyHDOa581/V2Sjo5fQM3en6y
	QLmRwSEqjYPAFDzszY61NA7yfltmdog=
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A29AdD03100663
	for <linux-mm@kvack.org>; Mon, 2 Nov 2026 01:47:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=OIisd8STYt04AoWykShpx5GEMDUc3yZT54lWY
	vDNDAU=; b=cSGNuTn1vtxd3/KBJVATRlzaQN6/oJ2kAZiiwxMONYPaC2LoEOenq
	rRsT4iyAubqcsqfzexrMZAJBoviyClccUYZH+DOD8ByWpv4c8T53f90jbaZuhqI/
	Yu1yz7ROW4ttnJlagtNqzEgVXtHK88nCiJ6suIe7B7QoFkyAMt2MX0dbKcuRfx1t
	Ow0rFGcLH85xjdSf7PTPSMKk2QOd9fAbYOATFpw9VatOd4SOOu2EUUX+IPK0J+1n
	fSec19CFqNiSjpgT9e3gLzP2sXheg619GLaLtAKkQozT3K5MGmDF0+eZFegNFX8F
	DsHdtoxjg3xgxOEhmCxRohaQDBi0I2KzQ==
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hnfmh06td-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Nov 2026 01:47:13 -0800 (PST)
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a615ab0c06so2684110a12.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 01:47:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793612832; cv=none;
        d=google.com; s=arc-20260327;
        b=NcnXoveZiPjnaRQdljhrRsN1JnbmfnbnEZg1ZQTxGRrEezo7qi5Kh+xwYbstcfkZEw
         sE9I02WlovhMIEYA8P8HhCWu96p7IxRpEwpN81vfdO0QQHtKaJSY9hBA2LUJyLg4ZmE2
         L3CgQEv04oL8htDdTQrBVrRPhGisCRH9R10QqqLzNQ5D1CaJ/jrUINSnM5+AQARZHEO3
         BwpR5SzyOUoDZJ8on47Alw0EECKg3+wMYma8ZE7MBpQm1SHL0aDsUF37L+Vude4i7bLR
         ipzdLujrvWifuvcNtb7m5NZikD6w6wQWSa/i8Cqwf/cGcGD1qJa/vZCxBZxGdEnNXB/J
         eAZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=kZFBqubIT/3DwescEkGovUV5S5nOjNIYh8rKkcY3QR0=;
        fh=INnkUzkWYqfVkvl+SE5McEJbtlxjuWRbyvG5klTkN9A=;
        b=pP8Zy/WGsc8dkw7sgOM0H6h1Nrr0IPIEPzKhp5sTQT1ARRkMlHhizVC6aSRjntpMNc
         AYGMiUcqQK1Jt5/KbVf/4gRgva0vOO39SqvX9b508X3SoVFOdpC06gN8Ld9iJdfrSRY+
         GYQ2oB9cn8i0nxUWUnwkMXz1kucRQjcyJ8cpJpfPEJI1sGvOeY2YnWqwA8zQficoza2k
         njycbUWY3sRVtKg6ztZ0i3Tfc8SNA2dgv5EXelO2ELqKZe0D0d3mfnghXduu+w8AMCa5
         410QuwH5sMsxu/zXpk1NBEpWPauBhStCq45cMBW6MWsTKL1C9W7beK8GjNbIBL2XllCn
         gNcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793612832; x=1794217632;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kZFBqubIT/3DwescEkGovUV5S5nOjNIYh8rKkcY3QR0=;
        b=ZWezD0CM5R3U4kVJw0z8r1Tjy3/fbd8Y5XrPXt5SqaNhtPiw+GRcRS+yEdWc41uHCI
         3c1TxvoCq+NTYr6SPOZdPlwbQ/uApDh6CVkYG0zyOCj9XsRAfu+xgmjvl/J/9YH/NyqG
         9lnUlS7SUS9pIUFVxZQNLu7CeihKmDlqLSKYQAh7tbpZrK/SbROcbggsVx3IYFZkBKaz
         uC2hGHfHvserdvOEBD8FiBddH1MlrDIgaFG6CyKA2p9UtlpAVFHxiOV+p8+kfh60rWi9
         o/5wbSoYJ05n/fausqxC0jJU8zL209OU3IZd60WOJQDNcAIsx6jnfj/vALygb1AJtebS
         8uUA==
X-Forwarded-Encrypted: i=1; AKwUvBzk6w0OrV79TxXlzaq/ttpSBywUhuvQ5O2K1X8vjrc72kD2qjC4FYtSfZP0OF7mZoIoYx//7Hq9iA==@kvack.org
X-Gm-Message-State: APuU4Z+CWMSJ83MAN7CQbQx99K/mz1mfhsYksTKp2/JqrYDizmvlyKx9
	TosOPApCzJvHAlHlQC9lLi8sdjdfwKZjG7kGcw4Eu5U8RLhcZP2cK+O2FEBEw88gEXL4O6M9imr
	ACdzSMRwN29Dcv4nr8WWI5lm1SFUirgFX4Afe/MvYmfZTmpd3hFUNrqe2bBNMHakLVHXwcJW/X2
	Hpxhfxfh/tnZP8G9LEcvObupH7SQ==
X-Gm-Gg: AYBFou3ZjL1SNho/ij6esDI4iO2KnwTwVvOPNP7SnZgfbOgTdvDOybmaG6C5KnM/x+P
	fVSc2lDBAoLW67vOWLLPxRe4shHFvPRo3NcVutVYElS/SMIOyvfpyEJJnGRD6L26Mlx3uFVcHQl
	qMoSajh6853ZdoWCXV3QWZZIvDZ+aJk1SWRv6RPa4gSIf/hgY3fABYGU6CdBST2Ajz4B69hekWN
	UK0WMGuSCb9EHQwSA==
X-Received: by 2002:a05:6402:223a:b0:6b1:827c:af27 with SMTP id 4fb4d7f45d1cf-6b4d42901d5mr4309426a12.14.1793612831695;
        Mon, 02 Nov 2026 01:47:11 -0800 (PST)
X-Received: by 2002:a05:6402:223a:b0:6b1:827c:af27 with SMTP id
 4fb4d7f45d1cf-6b4d42901d5mr4309412a12.14.1793612831129; Mon, 02 Nov 2026
 01:47:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022145615.2184343-1-alex@ghiti.fr> <20261022145615.2184343-2-alex@ghiti.fr>
 <CAKEwX=NWVVXXU76H3V0DWsH=VDbPmGUHZXeaN1_vkz8kwJCxbw@mail.gmail.com>
In-Reply-To: <CAKEwX=NWVVXXU76H3V0DWsH=VDbPmGUHZXeaN1_vkz8kwJCxbw@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Mon, 2 Nov 2026 10:46:59 +0100
X-Gm-Features: AclHuK-ko45jzQMTgG1sK5WUixbYj1ZnPkcnclUm_aBbtUmll1u_bLeL7VlXfck
Message-ID: <CAEmasaUBKwmTv4oj1V1yR+5FLMvEi+-oqzqH753N1xdm5-aP1w@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] mm/swap: allocate contiguous swap slots for a
 reclaim batch
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>,
        Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
        Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Youngjun Park <youngjun.park@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo Stoakes <ljs@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAzOCBTYWx0ZWRfX9vzpeyJX3WyL
 GPXSxi2xau/cTyermr5htAKUgaF4wo2CcHMj39AUgECjlyEp7JVxfMGUXMCLMU+IvnDm6HrEKoP
 PZ1/2y7cMdVy3XznJ5r/7/3m/rJe24lG66BZEPUMzGAAQKLgGTl9p+bTMpr1FnHWNHhI19cus2N
 RSSFdIEp1nDRluIS1Xp1PNRhV6vJ4bO0YvpdOLLkxJJZKNVl9t2oiFoCOGFeKS9tz8h+KP/bcIs
 uU2GwlQeOV66kUzopbeY/QnWXZAu1z6jo18qk+GZsd6pjGTwiOoOsQ5AIyIS8S98sDB6ecup5eW
 mTZ1Dt0RFJMqeYK1X4SWqgML8HKlN2GPcwsRsADnlU3Cix/CdNXlvJ5tu3q6c44KPl5+0NPodZy
 BBwwEmYBNQWdJ2CG5NTQuJVYu5ypedMlTo/v3V+i+E64I/KAOZU9s7jfkp6Gjcm5lcE11HivHfL
 oIFU74q0OPieTU+p3Pw==
X-Proofpoint-GUID: 2Ne46Pd3o3rz88LuypJzPukObqWR8ZTg
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAzOCBTYWx0ZWRfXyNHMFeVacTPF
 Bv5tkrAIqxFsV87j484DoNz1NaF42nAApPXNwJjxuKCO4m8TehyBEYEn6yFnTHmlj5q+uOoG6Lk
 G6g0nSoaPS9s0q2JROn1hNXi5MYbnT4=
X-Proofpoint-ORIG-GUID: 2Ne46Pd3o3rz88LuypJzPukObqWR8ZTg
X-Authority-Analysis: v=2.4 cv=da8VTnXe c=1 sm=1 tr=0 ts=6ae85c21 cx=c_pps
 a=DTy5UCxgudPLKrSn28m7Kw==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=crHB47gyY4rKiduisYu9:22
 a=pGLkceISAAAA:8 a=Byi6NZyOV6eMvFsYz34A:9 a=QEXdDO2ut3YA:10
 a=VzYV69SsQLkmnS9OQLw-:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_03,2026-10-21_02,2025-10-01_01
X-Stat-Signature: sm9e71wn8bujddwd89pommofsmqhsj9j
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B1CC140005
X-Rspam-User: 
X-HE-Tag: 1793612834-345436
X-HE-Meta: U2FsdGVkX18JxSxBoPHYNOsy4cHCrBNb7YYPVsa8cSTEhS/uLN+CRUqp8+t+NJfBJfDS9ZRwbdTzg8h85xXjbyB9bf5u+9xJkpfILtWArRVajITx1ExJHLEpVQ02q5q/P0hmCDGAnw3gyvQ4NylP+OiPQzZwRTp5DxiEdn9W2HkmAIrgrRtSEFUtm/Tgn7cPFQDK7uhf6quHWmyx0qbk+yf/XHFUNRgP3UcPTpAYR56yvu8p/QCQ5RxS6IX04gJn4QMJ2vLu71ArqRIfX0702DQ1FCYHU5bj805O4KdUVE2kbt556x1v4/OpynhieDOW7kHb9xn4OARIXYaRZl6LQtjDyZYtWU2uUf5yx7pZQ0omF0vBWxAVjD9YNt9PlTJ7vekam+8zeFx/K/jHiXpZbdx209XMxmV97aDsmMZBadEMdVmnKU0XARVUhSG6MoGqp6F22fvlGa2uMB64jq/54Nawvts8Dh1/AcA6VIikNS/njlZRjG13c+Q9pp4K5UBWHU4PecDvG0XUDsKbgFgg3qQ0PWx8HOqLPSE6yS37ibdki5I0ojF2kxulHFNfBBp87lqxq0MKldbHoxP9UxWyxmIiXYQFHmzZIHcGttc0Tdr0Mv1ajmiSYEJrkiNyghf5GHIhH+7ek8Y9CF/8O+StNBWvjgPC6H4dAleuL9Z17hpXUunBRbcG5d6KbGpcAhrTyzPnSYNRXHyzAQqcjEygeIR9VhJ2v+r+yYi2q+Lmrr5PoyI8kf/+WLMJJR95sU8X5KSjnAg1Tl7trxwoYc3bFDsjgxR9Hz7JAxZVl0HvaDKnQQJn6tYaxXBfz/Z+/PesYLPbarGUwlU7PvzrWyZPIQLdWv+7UtUrf81shs2gohQLCbRq2ktaIlJB+CEjL1R3Os7xSndtfwNdu22x473Ox/dbk4ngjqxCi4QWYZrxjDNSy3u+fwacjKL/2S+yA1yU07uTziHwHuWM8ozhpWJ
 6o/vXHxK
 XSEEwCZtASrkKCHGOejM95p43r1865tYuO986Bp/q74j0dIHYitmJ8qYtkfYjVCofhDRYmPLitfPulCRuNlBML3v3GRT9FUJ+CBgtl2hT9LJ2wKkM1PsH1lPXxyU5oAeUjXjWPakqSWj4Wae1zwb8liVCpeuWD96xTD9qyscmuSvp9706EVHZwO6XqNf/yFrH48+hr+a8oJs7wSyAUcuVOwUYzCiUOdbr5rcZZwPQQCjM1N9SdzVea7C+Xy/jw4W93AVDgzehGYkd5ngcuwwp64AJPJnuV6HeqMgaCpNx+k9KOaUmhtdupjbg760tjQdEuZUo10Dw2kp9Y6xkCxBiEWqfXNDgE/rIR7eR2RJ/kLOevcjRkotWlLszP0uHxogu6JMw1+o3i48OlircPJQ0EwDwQ0x7u8mbltC+3Ynwvg+OFgt2019xPVIQhzi8ehUXVGEv7AFTFaMOaIJJXNJc+XJbeI8t6vg6VijepPagRDHbnopniFg9UBfWVdnGKbyRa8uWMpDpd5d0dq69i+AvDfGjrBAnIMU26kl0+wI0HUSkPaAM/YwoqDKPfOqr1Sjwfb6QrhHaiys3malII3LNMymuGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Nhat,

On Fri, Oct 23, 2026 at 6:05=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> >
> On Thu, Oct 22, 2026 at 7:57=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > Reclaim allocates swap slots one folio at a time and only then batches
> > the writes, merging folios whose slots happen to be contiguous. Order-0
> > allocations scan the nonfull clusters before taking a free cluster, so
> > once frees have left holes in otherwise full clusters, a batch of LRU-
> > adjacent folios is scattered over those holes and written with many
> > small requests. Since swap slots are freed on exclusive write faults,
> > this happens with any workload that rewrites swapped out memory.
> >
> > Before swapping out a batch, record how many pages of each small order
> > need a slot, and make those allocations follow contiguous free slots,
> > SWAP_CLUSTER_MAX at a time: in a nonfull cluster if one has them,
> > otherwise in a free cluster. When neither has them, the rest of the
> > batch fills the holes as before. Nothing is reserved.
> >
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>
> Thanks for looking into this! There are still workloads that benefit
> more from disk swapping than compression swapping... We should make
> the swap subsystem work for them.
>
> I haven't read the code too closely, as it's an RFC meant to show the
> general idea. So I'll just make some comments and ask some questions
> about the idea:
>
> >  static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
> >                                          struct swap_cluster_info *ci,
> >                                          struct folio *folio,
> > @@ -1042,6 +1079,59 @@ static unsigned int alloc_swap_scan_list(struct =
swap_info_struct *si,
> >         return found;
> >  }
> >
> > +/* Larger folios already make large enough write requests on their own=
 */
> > +#define SWAP_BATCH_MAX_ORDER   (ilog2(SWAP_CLUSTER_MAX) - 1)
>
> Ah so we don't invoke this heuristics for folio larger than certain
> orders? Makes sense.

Yes, large folio get their own allocation scheme, here the idea is to
"pack" small folios, I'll add that to the changelog.

>
> > +
> > +static inline unsigned int swap_batch_contig(unsigned int left)
> > +{
> > +       return min_t(unsigned int, left, SWAP_CLUSTER_MAX);
> > +}
> > +
> > +/*
> > + * Like alloc_swap_scan_list(), but only allocate at the start of @nr_=
contig
> > + * free slots. Order 0 clusters without them move to the frag list unt=
il a
> > + * slot is freed, larger orders stay nonfull as the folio may still fi=
t.
> > + */
> > +static unsigned int alloc_swap_scan_list_contig(struct swap_info_struc=
t *si,
> > +                                               struct list_head *list,
> > +                                               struct folio *folio,
> > +                                               unsigned int nr_contig)
> > +{
> > +       unsigned int found =3D SWAP_ENTRY_INVALID, order =3D folio_orde=
r(folio);
> > +       struct swap_cluster_info *ci;
> > +       unsigned long start, offset;
> > +       LIST_HEAD(skipped);
> > +
> > +       while ((ci =3D isolate_lock_cluster(si, list))) {
> > +               start =3D cluster_offset(si, ci);
> > +               offset =3D SWAP_ENTRY_INVALID;
> > +               if (SWAPFILE_CLUSTER - ci->count >=3D nr_contig)
> > +                       offset =3D cluster_find_free_contig(ci, start,
> > +                                                         start + SWAPF=
ILE_CLUSTER,
> > +                                                         1 << order, n=
r_contig);
> > +               if (offset =3D=3D SWAP_ENTRY_INVALID) {
> > +                       if (order)
> > +                               move_cluster(si, ci, &skipped,
> > +                                            CLUSTER_FLAG_NONFULL);
> > +                       else
> > +                               relocate_cluster(si, ci);
> > +                       swap_cluster_unlock(ci);
> > +                       continue;
> > +               }
> > +               found =3D alloc_swap_scan_cluster(si, ci, folio, offset=
);
> > +               if (found)
> > +                       break;
> > +       }
> > +
> > +       if (!list_empty(&skipped)) {
> > +               spin_lock(&si->lock);
> > +               list_splice_tail(&skipped, list);
> > +               spin_unlock(&si->lock);
> > +       }
> > +
> > +       return found;
> > +}
> > +
> >  static void swap_reclaim_full_clusters(struct swap_info_struct *si, bo=
ol force)
> >  {
> >         long to_scan =3D 1;
> > @@ -1109,6 +1199,7 @@ static unsigned long cluster_alloc_swap_entry(str=
uct swap_info_struct *si,
> >         struct swap_cluster_info *ci;
> >         unsigned int order =3D likely(folio) ? folio_order(folio) : 0;
> >         unsigned int offset =3D SWAP_ENTRY_INVALID, found =3D SWAP_ENTR=
Y_INVALID;
> > +       unsigned int left;
> >
> >         /*
> >          * Swapfile is not block device so unable
> > @@ -1129,7 +1220,14 @@ static unsigned long cluster_alloc_swap_entry(st=
ruct swap_info_struct *si,
> >                 if (cluster_is_usable(ci, order)) {
> >                         if (cluster_is_empty(ci))
> >                                 offset =3D cluster_offset(si, ci);
> > -                       found =3D alloc_swap_scan_cluster(si, ci, folio=
, offset);
> > +                       /* The batch's contiguous slots are used up */
> > +                       if (likely(folio) &&
> > +                           this_cpu_read(percpu_swap_cluster.batch_lef=
t[order]) &&
> > +                           !cluster_slots_free(ci, offset, 1 << order))
> > +                               swap_cluster_unlock(ci);
> > +                       else
> > +                               found =3D alloc_swap_scan_cluster(si, c=
i, folio,
> > +                                                               offset);
> >                 } else {
> >                         swap_cluster_unlock(ci);
> >                 }
> > @@ -1148,6 +1246,21 @@ static unsigned long cluster_alloc_swap_entry(st=
ruct swap_info_struct *si,
> >                         goto done;
> >         }
> >
> > +       /* Keep a reclaim batch on contiguous free slots, not in small =
holes */
> > +       left =3D likely(folio) ?
> > +              this_cpu_read(percpu_swap_cluster.batch_left[order]) : 0;
> > +       if (left && order < PMD_ORDER) {
> > +               found =3D alloc_swap_scan_list_contig(si, &si->nonfull_=
clusters[order],
> > +                                                   folio, swap_batch_c=
ontig(left));
> > +               if (found)
> > +                       goto done;
> > +               found =3D alloc_swap_scan_list(si, &si->free_clusters, =
folio, false);
> > +               if (found)
> > +                       goto done;
> > +               /* No contiguous slots left, allocate the rest of the b=
atch as usual */
> > +               this_cpu_write(percpu_swap_cluster.batch_left[order], 0=
);
> > +       }
> > +
> >         if (order < PMD_ORDER) {
> >                 found =3D alloc_swap_scan_list(si, &si->nonfull_cluster=
s[order], folio, true);
>
> So we prefer non-full clusters with contiguous slots, over free
> clusters, over other nonfull clusters.
>
> I think this part makes sense to me FWIW. We do skip fast path and go
> for slow paths more often, so do make sure we're not paying with too
> much lock contention, especially as the swapfile fils or get more
> fragmented (which this patch series does nudge us towards). But FWIW,
> we pretty much go back to the old behavior the moment we fail to find
> contiguity for the first time in the batch, so I think we'll be
> fine...?

I'll check the lock contention, thanks.

>
> >                 if (found)
> > @@ -1390,7 +1503,15 @@ static bool swap_alloc_fast(struct folio *folio)
> >         if (cluster_is_usable(ci, order)) {
> >                 if (cluster_is_empty(ci))
> >                         offset =3D cluster_offset(si, ci);
> > -               alloc_swap_scan_cluster(si, ci, folio, offset);
> > +               /* The batch's contiguous slots are used up */
> > +               if (this_cpu_read(percpu_swap_cluster.batch_left[order]=
) &&
> > +                   !cluster_slots_free(ci, offset, 1 << order)) {
> > +                       swap_cluster_unlock(ci);
> > +                       this_cpu_write(percpu_swap_cluster.offset[order=
],
> > +                                      SWAP_ENTRY_INVALID);
> > +               } else {
> > +                       alloc_swap_scan_cluster(si, ci, folio, offset);
> > +               }
> >         } else {
> >                 swap_cluster_unlock(ci);
> >         }
> > @@ -1729,6 +1850,86 @@ static int swap_dup_entries_cluster(struct swap_=
info_struct *si,
> >         return err;
> >  }
> >
> > +static void swap_alloc_prepare(unsigned int order, unsigned int nr)
> > +{
> > +       unsigned int nr_contig =3D swap_batch_contig(nr);
> > +       struct swap_cluster_info *ci;
> > +       struct swap_info_struct *si;
> > +       unsigned long offset;
> > +       bool keep =3D false;
> > +
> > +       local_lock(&percpu_swap_cluster.lock);
> > +       if (nr <=3D (1 << order)) {
> > +               this_cpu_write(percpu_swap_cluster.batch_left[order], 0=
);
> > +               goto out;
> > +       }
> > +       this_cpu_write(percpu_swap_cluster.batch_left[order], nr);
> > +
> > +       /* Keep the cursor if enough free slots follow it */
> > +       si =3D this_cpu_read(percpu_swap_cluster.si[order]);
> > +       offset =3D this_cpu_read(percpu_swap_cluster.offset[order]);
> > +       if (si && offset && get_swap_device_info(si)) {
> > +               ci =3D swap_cluster_lock(si, offset);
> > +               if (cluster_is_usable(ci, order)) {
> > +                       if (cluster_is_empty(ci))
> > +                               offset =3D cluster_offset(si, ci);
> > +                       keep =3D offset % SWAPFILE_CLUSTER + nr_contig =
<=3D
> > +                              SWAPFILE_CLUSTER &&
> > +                              cluster_find_free_contig(ci, offset,
> > +                                                       offset + nr_con=
tig,
> > +                                                       1 << order,
> > +                                                       nr_contig) =3D=
=3D offset;
> > +               }
> > +               swap_cluster_unlock(ci);
> > +               put_swap_device(si);
> > +       }
> > +       if (!keep)
> > +               this_cpu_write(percpu_swap_cluster.offset[order],
> > +                              SWAP_ENTRY_INVALID);
> > +out:
> > +       local_unlock(&percpu_swap_cluster.lock);
> > +}
> > +
> > +/**
> > + * folio_alloc_swap_prepare - prepare swap allocation for a reclaim ba=
tch
> > + * @folios: list of folios reclaim is about to swap out
> > + *
> > + * Record how many pages of each small order the batch will swap out, =
so
> > + * that their slots are allocated contiguously. Nothing is reserved.
> > + */
> > +void folio_alloc_swap_prepare(struct list_head *folios)
> > +{
> > +       unsigned int max_order =3D min(SWAP_BATCH_MAX_ORDER, SWAP_NR_OR=
DERS - 1);
> > +       unsigned int nr[SWAP_BATCH_MAX_ORDER + 1] =3D {};
> > +       struct folio *folio;
> > +       unsigned int order;
> > +
> > +       if (!total_swap_pages)
> > +               return;
> > +
> > +       list_for_each_entry(folio, folios, lru) {
> > +               if (!folio_test_swapbacked(folio) || folio_test_swapcac=
he(folio))
> > +                       continue;
> > +               order =3D folio_order(folio);
> > +               if (order <=3D max_order)
> > +                       nr[order] +=3D 1 << order;
> > +       }
> > +
> > +       for (order =3D 0; order <=3D max_order; order++)
> > +               swap_alloc_prepare(order, nr[order]);
> > +}
> > +
> > +/**
> > + * folio_alloc_swap_split - account for a large folio split by reclaim
> > + * @nr_pages: number of order-0 folios the split produced
> > + */
> > +void folio_alloc_swap_split(unsigned int nr_pages)
> > +{
> > +       local_lock(&percpu_swap_cluster.lock);
> > +       this_cpu_add(percpu_swap_cluster.batch_left[0], nr_pages);
> > +       local_unlock(&percpu_swap_cluster.lock);
> > +}
> > +
> >  /**
> >   * folio_alloc_swap - allocate swap space for a folio
> >   * @folio: folio we want to move to swap
> > @@ -1771,6 +1972,12 @@ int folio_alloc_swap(struct folio *folio)
> >         local_lock(&percpu_swap_cluster.lock);
> >         if (!swap_alloc_fast(folio))
> >                 swap_alloc_slow(folio);
> > +       if (folio_test_swapcache(folio)) {
> > +               unsigned int left =3D this_cpu_read(percpu_swap_cluster=
.batch_left[order]);
> > +
> > +               this_cpu_write(percpu_swap_cluster.batch_left[order],
> > +                              left > size ? left - size : 0);
> > +       }
> >         local_unlock(&percpu_swap_cluster.lock);
> >
> >         if (!order && unlikely(!folio_test_swapcache(folio))) {
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index ea2d4c8d1890..86245036872c 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1175,6 +1175,8 @@ static unsigned int shrink_folio_list(struct list=
_head *folio_list,
> >         memset(stat, 0, sizeof(*stat));
> >         cond_resched();
> >         do_demote_pass =3D can_demote(pgdat->node_id, sc, memcg);
> > +       if (sc->gfp_mask & __GFP_IO)
> > +               folio_alloc_swap_prepare(folio_list);
> >
>
> Some general questions:
>
> 1. How many pages in folio_list typically do get reclaimed? There can
> be quite a few with references, which we rotate/promote, when we scan,
> right? Would constantly overshooting the estimate create problem down
> the line?
>

I need to trace some live hosts, I'll get back with numbers.

> (This is one of the few places where indirection (vswap) would have
> helped - we can collect a batch of pages after unmapping, then pass
> them to the phys swap allocator (after checking zswappability, etc.).
> Maybe we can solve it better after it's landed, and accept an
> imperfect solution for now?)
>
> 2. Should we skip this heuristics for cgroups that enables zswap (and
> maybe zram)? Contiguity matters less there... unless it help at
> writeback time? Hard to say without experimentation - maybe you can do
> the same check you did for your zswap writeback batching patch series?
>

I was wondering the same, I'll check how it impacts zswap + writeback.

Thanks!

Alex


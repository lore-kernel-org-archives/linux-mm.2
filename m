Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 183A0FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 08:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574166B008C; Wed, 29 Apr 2026 04:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524BE6B0092; Wed, 29 Apr 2026 04:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43AAC6B0093; Wed, 29 Apr 2026 04:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33E106B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:45:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4AC311A02D5
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:45:47 +0000 (UTC)
X-FDA: 84710960334.19.99BF9F2
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48397C0014
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:45:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hSd2mDSh;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777452345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hdxdo9CNH9jrEbKQHcrHRqJ+YPIlGV9yLVMB8VBaMPY=;
	b=EKoTRqRijK/ze6lnu+MnboDCc2FWnAiKxImqtVOuDNJ0Ts8AFUxvQgLLHF3QMS7aQc3479
	UPTaTxg8INBvarKopWvB+FyiN0fLJku0Do+LPUVkLJFFC+iRRQlx57RzsrEDb9VWfx/MCg
	ZJXhih9RExPfZXImHh5w/KeAt1HB0y8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hSd2mDSh;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777452345; a=rsa-sha256;
	cv=pass;
	b=j0nsUQ38s8Rde1DxT+GLtTYR0B0nhOGjxYB4yr0O3YwL94VWieJRgYwIfgVfadldV/3NNt
	cqFmfFT3os+Kp1jC+Zjv5HhENbhyrXQRtrpjQqML3rHtF3T4ypVXv8PbHPy43ja4e+IJc3
	frYziKJIXSFgZQTO7EU1W9MgImuawrs=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ba8472c1613so1794522566b.0
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:45:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777452344; cv=none;
        d=google.com; s=arc-20240605;
        b=c2WJfvMpMBrQn2mzQqtA3rQdK5athlthBUNNVtzbK5et6J+U0682U/g+M6FrGVCKcj
         xkpL+Okd1z6NnmFGr48c9c4ZEsPY1cXmNeLmakQCbhiwA0EiYerww4kO3VjAZYW6jcBY
         cyI8x1yf2S9NUwjj2FFAhVFUqW83UqwIMb46aJW84AfEERP3i0ptFX71LKnENIMsaTiq
         x6G70Apy0giz/q1jvBXAIv1ScxOZE4eeaictaVZGkHiQp4WZ78ChzcVM4TV4i/8ayzkm
         63mLKpWD/UtZEoyEdbj6nwxE+pBqno7yTNl/rryGLRFQRNMg7m5NO1bxf6WZJ2+Wm4or
         tX3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hdxdo9CNH9jrEbKQHcrHRqJ+YPIlGV9yLVMB8VBaMPY=;
        fh=NT2urvd8d+2PS6ptjdxOHCoWK3yrlMNZdXzyv3zaRrA=;
        b=AqGfS8wiprFosjIRCMmLcTg/aZ96/yVGWSCSi+s0DJkoeA8x39+DuP5cd4Cl/NDPli
         zOMh+8G/xkryzd1Y1JmqqRB1vwJJHUGi70DeYypeQ6Bfa9wglWJox8+PCzcsTGpnFdLs
         3Y2Ack4ZeffdEBRXA1U+6dlYWc8E2c4I4EDjO24HYniiYxLq7UI1F2YPptdSfhi5KOSF
         yEQN1iiCDB8dekrp5rmfvt44tFWJmxL8TlMGs6YNWFu8i6LN1U4kwscoC98g4sN0+une
         3nDx2FBi4oKm+G9n2SyeqNqQTUsvyHM8KtW7C4FAdgL4nBNkkQeMgH4IplR44j5sZr2s
         HWBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777452344; x=1778057144; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hdxdo9CNH9jrEbKQHcrHRqJ+YPIlGV9yLVMB8VBaMPY=;
        b=hSd2mDSh3WRC1MPjAlkOj2u8RrByzgUjWgwczgyzmu4gfbxDdYc2tXpbJ03kSFdbbc
         5K+uLvlUi8YKPuS7OpBF3ekyvy6YVaMRfoeW2msB5Qbi/MtD6/4ckpVkNRF6FiGtBNgs
         5rXRzG5+5dKKg5VgUdeW7akZ/iQQO2UKnZj0c4/YmMwxcaeUxFOQNgob1VgSGhyulTd3
         lg8ZGVQvswY/8Xgvvvwkw4OTat023HryM3ADWLDN25hAU0wdxvGXn1eGG/L+7cFCxNEH
         5ZNrjxRqR5lvOBXiczKX+cps0A7m7wDzfSzSHJVLsXqNODAj7iHZtxrQjPVFHr/HxNll
         6G9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777452344; x=1778057144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hdxdo9CNH9jrEbKQHcrHRqJ+YPIlGV9yLVMB8VBaMPY=;
        b=o7y1uOqOeqATxdHiS031M3i045HTJKOL6KjSb26uFzaDZ+1psdduJ7Zf9UPqXS/2y7
         qzkEzD/K9uJedX8MozLnU4BpK0w8CPliSPLfzE3KWY8oDE95LSJT0GZjwRR92Od2P2DB
         YPgSwVQGeL8fao+pew+s4ULtJrKsecE2+Dx9dG4tzaNdfPtDZANggCA75XLBwheXcIFz
         H7fpXKxMqnFlwK2he8+H0LCq72RTUdhx3j0lds4y4g3MtEcVJ93r/I/al52gwlPwLPUH
         EApVcsQj3WIZbpTDB4AF9OZJC4vy2OBU/EzO0n6Ce5r1wk3n9+90pjI8gdms6X8cj0y0
         0jJw==
X-Forwarded-Encrypted: i=1; AFNElJ/CRxdDD1JmhjY3u47hsHngf5wzwkuKlhNyxjShQGAmxklSSJUZM8o5tlRgu9cokUI6GXODmleq/w==@kvack.org
X-Gm-Message-State: AOJu0YxYLEyGcrKN+4tDMIcCrIz8NpQyRH0T+EKcVnGQTp4FI9raWwox
	um9h+Uk3Z2T+mKwJ8PmPbJX0Kb7Kp2tzXUby/XPxequPkSLckn/H0dDoyfBbuh8CDbYtTZIgD7P
	xMTiDEksjVXcJNfx61cm3TXqYDXozxuc=
X-Gm-Gg: AeBDieuGfa5UmkkQEXz4VYGxubcaIEpr0XoKGvl5mITAGD9EnmPL52Bw4P/bThUCxAA
	Tnqp465shG5E9rQ/n9Dh8KnJtKMKJebWeoQyqVTwRUGbSBaDyXcayTc/xc+rpSACsk48Y9ybTX/
	WQ6TeSJX8gI5cDVQiiiC3a8BkhTqsQFDXpTmgmvQIvSmJZhLR4xEc40lyQE9UDq2VVowlDdXQ/T
	p30dPPMDoq9lmvurDz62Fq1K+z+clmtv04/5PvU4I85X5QZR8+eslPdtdbMKLgGRjdE15iIm9RA
	600kiA/K0Q2yu/RSFQUQRNTFj98Oku8GGXOiSea/mcUj+UvcXQ==
X-Received: by 2002:a17:906:c105:b0:bab:c646:dc7c with SMTP id
 a640c23a62f3a-bb803e63664mr416828166b.34.1777452343433; Wed, 29 Apr 2026
 01:45:43 -0700 (PDT)
MIME-Version: 1.0
References: <BL0PR03MB4212D07B8FFF03DF6EA45F9E84282@BL0PR03MB4212.namprd03.prod.outlook.com>
 <4a339042-0b63-46a0-8400-e3854cc979e8@kernel.org>
In-Reply-To: <4a339042-0b63-46a0-8400-e3854cc979e8@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Apr 2026 16:45:06 +0800
X-Gm-Features: AVHnY4J0Fq4Y_ilH7wwXjmn3I_W2DCXSLO3ivUiEwkXo5S3No6y8vSEZ6bnfOgM
Message-ID: <CAMgjq7Cp_w3T98FAs7c-uiRrPS6qWUWf2bh3OkheV3dF8j46Yw@mail.gmail.com>
Subject: Re: [BUG] KASAN: user-memory-access in free_pgtables
To: Huang Forrest <forrest021@outlook.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 48397C0014
X-Rspamd-Server: rspam06
X-Stat-Signature: 13meweyz377s8cg76hr99c8cz753cbr8
X-HE-Tag: 1777452345-932924
X-HE-Meta: U2FsdGVkX184EwSxIh8TZ++2vXJ160wGUYnRPSEpm9takUNMNPHkJdASV56MwCTbUMeHBSSqhRcNFjsRazQrWEqf+vv0I1y4BMU5JvKwcdIR9z0TW8CilTLu2MOrHym8xENT0aiJC/lsU3JM5yG5ieBQ+YABkVm4SA/B2HAKNbRkfpMbErGwVwlF7PFLLeCTbws5K7N6Y3r3hRIcEEYEudSy/cxIke3kHHkxzQ/TiF3nySDhnAYMBSurfLd5pBSObg6NBSYoD3/Ka1/xck5PfsfVN/4SILzq7crMs8rRTswTNuwAkTJaW33m/ZtqREt+RIBgdtl8OnbIeQVXz1tCsR6mmQtI22YhJngVAa35kCnDBptmvcBoioJdYLPD+S+69QHCXDLEq7UDcMjQlwilNjmsS0UQm6Zi1Me7Q5ZmdQPLuBzVv55UTujI54kSyKzUmuZkx5dSX0gWhbeWyhC2lhZR7VgZFh7BacmutuCOmcH0h7SzeyA85A8lAxTydc+lxpcle5JQiujroUuESNTgPq12/SyQjAbtu6QifKIYfFNcIaj/9dZabNJ1ZUVnasQverZEuGPL+vjh5XhSXbam9OfPLiwRj2iepX+HYI/bkeyXY5CIRcg9OXJ2L6PEE/kxTjxtQAwqJm+u9cXcUoLftNJJmcyMVIScBvjbibu9rz7D45iBax5hz0KBixtukBf5DjJin9nJvDzbncPtyOTdFSVm+aMbXW9immeJVP3GFAS2XqpFRNSeaTozDP+41LR+kaoP2W2GpJ7+3HbRFnqjLBcbF1YOcPe9lObkoEmX/VDW2tg29hXgn9YHJ8zb3UkoclRU12mzKXqs4c9Ws00nJC58xqlPhWCF0XIQGpBnp6AQNafyA3zLxjvnMkIVqvgAyhcqYyVRDMdxDYgNqJFAkeTy/xQyp42ntvE2BOrVE56AHLriZx8mpTG8isMOSlbEJ/6Y1CnVivQbxKwPLoy
 DlYXaoz1
 GjTFaimJQvxX+GrcGPBw3QeQCYfJQuoo282YXzx8TuokL5jtVySwMKP95nji1k0JLMVTKK3qtYNjY5WqnT/VsypVr5uswHvVdFvX4TpF1iula81E9zS+9VD4uROiEyDMMZxG4vw/jTARc8RssGD/N15mzh9P7HdwE+a1Av+QiH+EG0gfijUADoVVsdIQ7IAwCZqCnLOZ7yqbas9qztl5p17Stm9pDSF+F05K0tQbxjeGqs9hMEwGG47lD9Q9fVb2MK9Jb7y/MzQ3q5MwGWMEGb8b8/zalF5GKW5Gtcd8gLAFAtyMVvmUNNgbhifUdDrIHmafquJ53fFpOG7p4Ftfsou61+dkVE1ljXUO2x3JGZ5MgKdt/5E34a5ub+N/6cWh4xu/ESsWYD0D6QMFzRjbogTkYz+jZTGbx4y2YyFNslhUX1JmT2xIpGUKr/qgjKXeN7Cl57GfuhQliSYEJQuIcOSFb9OD0w6fuwoHSkb1v8lDRdwMzXJSyVSdvsCiUNpxhl3gjaAO5bxlYgLy+JyJ6hffYC8L9Y8WIZS2HwTOJcjqSh/sox89s1fnOci/xCVTFHQ9p1dsvBJ7EuLaBJ8ohmlLZng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 4:09=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/25/26 11:50, Huang Forrest wrote:
> > Hello,
>
> CCing swap folks. Did any of the bigger swap reworks go into v7.0 that co=
uld
> cause this?

Thanks for the Cc.

>
> It could also just be a corrupted PTE I guess.
>

I think it is more likely a corrupted PTE issue indeed. Corrupted PTE
often causes WARN from swap side on process exit / unmap zap, the swap
file entry reported here looks like random garbage, not an entry
allocated from swap.

Swap free helper will just return and do nothing after that WARN,
following panic is likely caused by other corrupted memory or bug.


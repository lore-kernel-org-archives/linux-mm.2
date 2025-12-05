Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DB0FD2F7EF
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 13:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF8086B0145; Fri,  5 Dec 2025 08:54:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81FA6B0153; Fri,  5 Dec 2025 08:54:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49AA6B0154; Fri,  5 Dec 2025 08:54:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC0ED6B0145
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 08:54:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E146138AF6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:54:56 +0000 (UTC)
X-FDA: 84185563392.28.9D51EAA
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C5D68000B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:54:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FviYcjdk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764942894; a=rsa-sha256;
	cv=none;
	b=0d8m+5LGfclbPxMy+rXmgj/RHR2+sBR4i6F/VP64RbPb6kEjaHlQwVFEW90Sb9SN9v0DCU
	z6Oapp/Z9rApyhseY61K5EUii8GgWh8znpkV7sTtJYCFI4V2zteMBehmdcltG3oKyhdnBm
	zKewm4Q7MH6mX+48a7HicNMc9ckDmC4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FviYcjdk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764942894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XqA0GadxzNDdiyG36a0fVSlW+wUaJcQziD5Q44Wd8q0=;
	b=8abWhhkcKXThSHxXLW064utRd3wu3B+sqi1GeaRAJFyf/uSIJ5cIm8o8RXR83unfsTXGqa
	fDXccchXmnYq58ju0zKxoRegm6Nm0nYAXW5DUbFLtNiFrySrCMg4LGXpvUdsiFwENt/fvD
	Qv7zoqPzSmb0dRbDaRNKvAIVYXJNZGg=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42e2e5da5fcso1412892f8f.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 05:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764942893; x=1765547693; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqA0GadxzNDdiyG36a0fVSlW+wUaJcQziD5Q44Wd8q0=;
        b=FviYcjdkXiNFju43yy9xKE8uN01EWqcwee0uSs9qVaANUmTkbqnly/3V9DGAN7pwtk
         XN9ZXV7B/Oc7vSLv2jcghEaESPdJh2pZ43b90nSPYo0+GHVMiGAc5FCz3F3Q8KoYZ4Vi
         v6oGVXCfOjR54GfBMEYC2qKYZI0c0lOBKcM5Kq77aAMuwFiZNwLncp07q4I/scfKl2qn
         tYe8TJmX2l536tOppmycJEURjxL5Ei/s0fRoStthDJWlvJNKSkN5X4Zfb0OTSJPbpAyx
         fYr713CXvsli9cilJ4NVF8DRlyO7wHXJONAlGzvTR3pVy2S12Vy3ArRdQCm05LZWpkix
         NcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764942893; x=1765547693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XqA0GadxzNDdiyG36a0fVSlW+wUaJcQziD5Q44Wd8q0=;
        b=v8R4TRI89LVKsagU6+rIz+KTXYro5HxWW5cL1O9B9chYozOW5fejv+T4KLqzMuMGeC
         ep2nX3h2qKBcI1H4/9LGYC8hBAdwVnlVTcS5wxO90awU20T7B+UI461f+9ibicZqKRZZ
         6ScJ3fmG9P97VChd3+MP0bHZoAskW7GjbzdC2fjgxdK+oE2mFwnCo2Cu4IIxzPPufiM2
         4CFQ3MWI8jUG6mrQs6wiY2Y25nEB0eryBUgpjRRRK93+qhhs7WEcVvBjZ3bG2iTS7BWy
         JdJlwWEiP4CUpIigRMQsIcdnOwgUQ18TBhL12vKOtiZQJjWn/mDPjkqx3ahrdt8DOuCQ
         UHcA==
X-Forwarded-Encrypted: i=1; AJvYcCWvnllas7PwLiDQKh2Ml5Th0d59sv0xbyJMTOsaMR8/eJxT+iO1Roo2Y2ZcD6GBaaWEoBhitZI5ZA==@kvack.org
X-Gm-Message-State: AOJu0Yzh9di8nLVCOKKDssqjhb5SAVIB/UNXdu6iVpxePOdX6IOajJQQ
	J50Hol2Bj9Ra9MP2EpVH/Zd+z+zTla+9eXc5Jf5iPsMbfiGbj73mabA4GcALqSU73arZjbnnbXb
	k55m2jP6oK8WYwLrWMD+dDuy+SENdEqM=
X-Gm-Gg: ASbGncsTs3elkbTIpBBw9Y+q06E198pjAA8oB+sI/80V5ruDQPBN2IEwdNwk5URkOBH
	U2aBGW19eiYCRCNMWomJmD2LIMKum8yxiUNQUf1QXlk4poBoy39V4rHs7sv1JiPohsXVvR9YCYn
	HL2F2LK5Bf/Gcn1S1WlblfoLA4051dbE4R5fwOJ2YYBhwyFu3I5rpobz3MMDc4i5IFkejg3HhW6
	7w1VuTtKyRLIEE3PTXAd9LJGQ6o+qU9Jf9IjrH2djxekvnnZx1syEFtQvHIxDz7gIA//8koW+nC
	UMEW+1WY86QNSAdfCcwnu580KT7md0GBHw==
X-Google-Smtp-Source: AGHT+IFKSWTL3hPVglpUiyvk1EerA9GEspZ+MoPANPg5V4fZMvViVoVP2v1WgBqbthmdzniP274hp3CHzGJhnxBcszg=
X-Received: by 2002:a05:6000:430a:b0:42b:32a0:3490 with SMTP id
 ffacd0b85a97d-42f7985ea53mr7266209f8f.49.1764942892496; Fri, 05 Dec 2025
 05:54:52 -0800 (PST)
MIME-Version: 1.0
References: <cover.1764874575.git.m.wieczorretman@pm.me> <873821114a9f722ffb5d6702b94782e902883fdf.1764874575.git.m.wieczorretman@pm.me>
 <CA+fCnZeuGdKSEm11oGT6FS71_vGq1vjq-xY36kxVdFvwmag2ZQ@mail.gmail.com>
 <20251204192237.0d7a07c9961843503c08ebab@linux-foundation.org>
 <CA+fCnZfBqNKAkwKmdu7YAPWjPDWY=wRkUiWuYjEzK4_tNhSGFA@mail.gmail.com> <qg2tmzw5me43idoal3egqtr5i6rdizhxsaybtsesahec3lrrus@3ccq3qtarfyj>
In-Reply-To: <qg2tmzw5me43idoal3egqtr5i6rdizhxsaybtsesahec3lrrus@3ccq3qtarfyj>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 5 Dec 2025 14:54:40 +0100
X-Gm-Features: AQt7F2o1xS0hHM8DgwvkRj9a0T3Q-4e4zvUroh1u1jgGrLZaZp4ZkwOF-iWjFVM
Message-ID: <CA+fCnZdHU=0EL2nedasTCRUjo45RHg-U=0JTe6VrAiG=90cm4A@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] kasan: Unpoison vms[area] addresses with a common tag
To: =?UTF-8?Q?Maciej_Wiecz=C3=B3r=2DRetman?= <m.wieczorretman@pm.me>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver <elver@google.com>, jiayuan.chen@linux.dev, 
	stable@vger.kernel.org, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5C5D68000B
X-Stat-Signature: cwa31ad8rkb1ihnj1jr3iutdm58etsc1
X-Rspam-User: 
X-HE-Tag: 1764942894-565433
X-HE-Meta: U2FsdGVkX1/WrEejnr1HQ4hHJoVk8YXkrPH59bNmWITWlL6Znylid0K6biwFXt+yZiNdJsneNxau6WTXSW2o6aKt2alhJWTCjZxcJDt0SEQR9upmaOvHgylmvEox8oJK8sb9Lc/D/JCqTwgHFGGrHDJU/jqr1S4jPJ+kG2Lwy5BzvX+ur0Dc79l16Jv8QINGsp6SnDEWJfecCqcFCsPfkJPKY9h5rETMXZ2kISnNjQfhksYWtYqdd3J9bzTjhABD7Bke6/NT6m2DTV4EjoxqhwEJEMM4VNEmvEd+c/seeDAYSFJ8i81x++IUmsrOBDM1y5iHg2FRks7p32TY9bvLrFrnDX9gCpodJ8E9oTkovQPmcS9vaGRRaeJipUU9r8OJOiTRZ09539PLW++3EEamfa92tgmDtchwMz1xMcrU7UR85p8cmAzpXIwSXT2RCF7Tx6pCULDlkcR9DuZhFYXwBjx8tQSPrV/9a+M+xSPYa7jWdjIeNn+fIacVhmR12EGY60eMio8iJJoyDuYVEyX99OHGuN2HzxXeSQEjCRlkdiDByCAQt1IIGvvAIEfe5+ihWV1WJ3yU8xp9SQqf5wIV6RDKO8u7bouBfSLzYxHYS8zeUFS5G24xjQdY+vscmG/6V5bknvSh1moFVhYgwb4Wot1ka0nO27EXvBLvmvw8A5bgquRFjTGi3EGqcXWpZ4msdBXPeOq8hMmt/TZLp6o5Y6LhyhB7pVsVizifvifaDZD6jlYyAMFq+C1b+Lb4ecWQGKJxpgTRRY/8rn/fVIFMRpeugZz2F+JGNv50xHphhjJ0XxinmeB8JqWWbMUtsKXnB9E4sTLwWNQxXCD4l7edDzM2atMAn9qe/4me98R3I8j554v1G1Us69nhN+Yc8886SrGDSqTEgeAes1r17BAp5uwXzdFELEYY5VXFNxW6Q0Xt854DRXP2qx1ZYbEgaxVAGvK1iFGNQb85ZrcIdGa
 U2LYbw9j
 YlOQuLcCiZDtv4s2WwXzIxyD7lli+YkVi7vpEoIAvYpwZQ6qtSdf4cHM9UeFNfh6C+dWYquR2HLUXdvBPBZnPXLjKVT2F1kMWTdM2tH0ViL028EdKRrUDGR4XPwW5tmUSuAITKx9gaN2lMNh1Lwng1cI5g3Rnu5/fHRav6/OPEfMiXPWzbmFEdd3EKi4YdKmNHwXBX1AMkqGTE5ZXTANMQaasUe1dv1W/irTez80I7w9DzS3J/lqz4C1SJRZrirk23rbQwQi30FHmQc1KyQDVGlwq/Q3sQqAJdcav93jWV/V5Ab2+bDHzbLF1praafc+XjnRlGqLIklv+MAU23r89E/LcXUOKdByIWYjxiT2/oDZptxhzUwSDR5dALHB7rafRP49l9GKapRVUO6zR2mHZhLKfr2aOBHbh4HAzHPja07XJRVxI9CJ0OR1tAQGsdtYkOLvV3EXcjPLpLLVDlVsV79NGRMEMtVVxl2PO0iN0N59Rj8M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 5, 2025 at 8:55=E2=80=AFAM Maciej Wiecz=C3=B3r-Retman
<m.wieczorretman@pm.me> wrote:
>
> Thanks for checking the patches out, do you want me to send v4 with this
> correction or is it redundant now that Andrew already wrote it?

Either way is fine with me, thanks!


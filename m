Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B58D2F32D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63AB96B0089; Tue, 13 Jan 2026 14:32:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E86C6B008A; Tue, 13 Jan 2026 14:32:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7A76B008C; Tue, 13 Jan 2026 14:32:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1A96B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:32:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3BD81ACC97
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:32:06 +0000 (UTC)
X-FDA: 84327936252.12.C5CEA0E
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0841B20007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:32:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XnzkuYwA;
	spf=pass (imf03.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768332725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EM/HXR8i6XoI6VJl6+fgNSFc2uahyunFLqLR7E0qUY=;
	b=vbKoc3+B5Mh8V48UkPBEkIWkvnvEu9rQCqmbxS9wVrXQpEhUW2iljVT/R5YMKRZXGJ5ZXv
	O81rTtcLtrgeGFNBT96EhdVZqJrKyC+EUo8BFc4EM7EXSKkRA01OwzcRum1B8nBcdxbp+i
	uiXBLnynutKvtEqw2sI9YrLywRRjFF8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XnzkuYwA;
	spf=pass (imf03.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768332725; a=rsa-sha256;
	cv=none;
	b=g7uZgx15r4LhMB4psM+1f/xpO7Lu6AGosE9xLWInbsWzB9rDPy9w17ubkuB7+7sKzO6Jq9
	myK1BzQwY6SrJT8sw/WjTlNnF8pJDMghfNm57RY9MePkqH2dee1I7xkqr40tcGWQgbSqk9
	yktVDGgq6GiFv1y2dVNmcsa05wcEzv0=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47ee3a63300so21155e9.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768332724; x=1768937524; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2EM/HXR8i6XoI6VJl6+fgNSFc2uahyunFLqLR7E0qUY=;
        b=XnzkuYwAijJwtnbsAdm5ewU+RAXxqaVwnoamFCKVCH/pz5+tPmLsmfOAbf0+kZhLkM
         htBLCMzgX8o3ybqlfLIZ1Rj5bY5YPvkpVpxVcxQb9zrGrxeWxNg7YzIrpTKeH0INsMLd
         K5T4/sGRsPjqf0nRQPHVNe0E2DJxLvXUfttWDYNd4oNcvcCE7W1lBJhlYqJk3ZO6ufWr
         gZZmDsWfh41wXNbWFZXeZtFv55DHSlTUfHzrxHqLdS/W5vmy+cpl35XISy21LnZ26VjR
         dz/8UN5KDVg0cYhaxG+bzNI9UtuPIdjlbdsff1f9M7va35NAIHHgcUkD5T2TabH23S/z
         jJNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768332724; x=1768937524;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2EM/HXR8i6XoI6VJl6+fgNSFc2uahyunFLqLR7E0qUY=;
        b=RZT00VdmYG8+LwyG8amd+fyR9QwOuEHYp2tionz4f4PjUn9LLE6T9ZLhOtLRZ1GHxU
         4/YtuuZkPV8KRIDurZ29jmi3uoWOpIs2idv9rANIYKKs+aHqpMjA4xU80iAT+zCJ8w2f
         4hvq2a+ronr8eww/dkiN9CHnFZZkiVUoz+O+UAU1TNk4kYrwyPnSwD5Z8zLAgJMEnww7
         Lai0clsc4PbBVbRyFIjMuRUNDwtrsKPEyx8R3GCLMkeXhs6eX0do6ZcgeMhjaDwZl00U
         RbQis9Xw3alkFlxn4bdJW9NMfieNGqDrqDIRLVpSk6VvEPs7sPahHp+DcFkbZvQbAf0I
         RFGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIvjQvx/zYJUWYGNf4o/QX2PoJ7ZdjNF+TQxFadzoglxGHcy7BZD79GEm6+fCH9g8CMu0Oe+Q0Ew==@kvack.org
X-Gm-Message-State: AOJu0YxjGDE5P+kPha8HWpL32pIf7ATLWrczVmmwrhPS8kdAVG8VRXrf
	oS+i5iVW7DvASzLB+eWT+6RehMGDubXiuiCO+2MmSM7GXJLxjE3tHlqWhMJZQJuh/YKli6xleHx
	nJ/RrCF5ALXWRsOebNzC4vhxs0/LvM3M+QdZHdpVh
X-Gm-Gg: AY/fxX5iSbQ2umveyt/PzfaVYJLeLo+LiSNdzrKfZrgFRwcXn9NQbmUumxVuBF+PE9x
	I2XJAt3lyDz8W3oYBZTSGUY6Ct9jnd0XN06fbO4B8re/XTCmifehzXJX97U3M1RwqprlKRuvfpA
	tajVZBLZ7nqR9AOD+66Z99pa83bnr1eri2RXcjJPLpFT6lKomhzwmXlAuB7tbjSuXQaMQeJd8UX
	MC/25ZfrJGf+gtzFlhkdzur4XnsUA3OtZ+4ziLheQL9z5DBtVUP4D8g8zBuSAJjhjU/6Cp4lxmg
	/TFjiKlbJ5+d9EmGPGS8Vwj0Ow==
X-Received: by 2002:a05:600c:1c15:b0:47d:3ead:7439 with SMTP id
 5b1f17b1804b1-47ee339e454mr2674375e9.37.1768332723438; Tue, 13 Jan 2026
 11:32:03 -0800 (PST)
MIME-Version: 1.0
References: <20260113192949.689834-1-lorenzo.stoakes@oracle.com>
In-Reply-To: <20260113192949.689834-1-lorenzo.stoakes@oracle.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 13 Jan 2026 20:31:50 +0100
X-Gm-Features: AZwV_Qi7Bzjv-dKzq1Xb-JuRodbFd8y0k7GJp27_jv93nq2MEefd2rQApS7HzMY
Message-ID: <CAH5fLgg4_uZrFXy1maSUQ=0xE+tyzyWEV8Fyh1R_B0ww8N50Cg@mail.gmail.com>
Subject: Re: [PATCH] rust: fix typo in bindings
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Chris Mason <clm@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0841B20007
X-Stat-Signature: aets8j8w3gxx54eb7ay1hegen3t54kw9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768332724-913398
X-HE-Meta: U2FsdGVkX182SoMtASHT3qLXy7C53wMx5wkX+NTvSRyPf+kOoKdJBc/TLnZf61nbUW/WoHO7kYDDzmxV0XCoA+PsKPS/MyymKZVxLDFprH0ySNTH0bHAdfj2mQ5OT2ZcNgtUUCrGgaJ8ln1WoFFOuIiLvYlygsL4PMdOCen/G2TJKfmXrfV35bQxE8BhcuUVxzueU/krsD1DaLEBX2unmwWrCganlJkUCiulPPBAiWn5+kVn9HSIgL/BGgrnVg5FVHHiW+Mw19o0zKd3+mygCO4X4tDAZaYzAtOkNyoWEeTImUEmYYLau1l5Py8SKXuctG6WPiU3y/zkZoVWOKkB7K3+lVACNGlcy1QI5yiBxgsrhNoKiugYrQ+7MT/KxeufyhB0yOkuczvknp6ZGBswb8/cUtTOT0rDQPyWLmlGvRWU1MdJWBzkiOMubZvhWPPGKllNaIjkE0U5aIisLlazu2jpVN37dz9YWpYVfVrlbFl6BP4sumgL/qPbyYsBhiSURQcAHKeH6fYinT3i60b+c1Fw3ljwUhr2sd/J85VwDJhrbUdJOWTSQPkROKXF37hAhYM+BD8ib/Y2vobSkSzkrqMg41UXdbV4LzyKeJoxMO8//GBo3k8OEtxiuFy0YjwwkorBsxYYXW8e/N4Zheoa3mgy2vJnvYIwwle/2+OxcT8w9ckizMAgTg0V20YWvubN0ijzYaBP5DWogcKhI1WYKNx/FeWnf2pp2EwQu2IIHAyzpUVd7W1uK6jSo4wWYrPxq+wIjTCll7ngYM7qi+fP/auWoLOV0NFMeJiEY+ievzEgEFncJHfWg8yFbHYbIgD202aQgReEKZuU9v+lmsGITJEHbiNCTpuzuHoE0JPwbAp8Gon/IrhYA5ZJG8DcMyLdKKtsEiaPEVxYykpAm7dOz4cZWWW7bxsZYZBHIqb/Hn2c7oBdZh7mlaRLHX2x4MEI0ZCVWF1OoPQwFf/x1Bm
 GBJ4x9EN
 4+ZOgstMA2gR12kwfL2J+0LCqdE81J4T571nThDGH5oU0zwVgMqLMiEeIxkCs95NbBapA8tT5+8bj1OttGiWUHKucEJe1JMdOBsn1KQEUHv2beapfZAGJQa8oIpUDFIF+Ybl2XjI+CdRuaaurSoSbaVy0BsZkZOA3owyGbZcCBB5Im4V4CP0e3iZVXGrQjxyh5XQT0DYoUiTUIhYgIK6/iBh8kv3/QxAXcAk4l26Zl/C2FE31RFruOado1EA8Ezw3obBFD5M0Y27IPqmDziZfsYX3vmMEiJcBi7w5UDeBLYq81yLAV9h3ZdvCYdNlg/KzmWM3pFOy0rfi9puLWF50c3rg+eq3G6N+8BkrCP6wI4mQFMOs+RWtrF7OJCg0+GzBJ3ztftpQGcmJMbE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 8:30=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added a number of
> overrides to the rust bindings helper as the change performed in the comm=
it
> caused the rust binder to not be able to automatically determine values o=
f
> VMA flags.
>
> However a typo was introduced leaving VM_MAYSHARE to be incorrectly
> interpreted as VM_MAYEXEC in rust code. This patch fixes the typo.
>
> Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
> Reported-by: Chris Mason <clm@meta.com>
> Closes: https://lore.kernel.org/all/20260113185142.254821-1-clm@meta.com/
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>


Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2CB9606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=VlM7DWeD
Received: by kanga.kvack.org (Postfix)
	id 14C5C6B00EF; Wed, 11 Nov 2026 15:56:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124326B05B0; Wed, 11 Nov 2026 15:56:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039926B05B1; Wed, 11 Nov 2026 15:56:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE0DD6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:56:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 511641203E2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:56:21 +0000 (UTC)
X-FDA: 85424046162.29.26AF872
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0FE06A0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:56:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=VlM7DWeD;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794430579;
	b=Ka7qyC8pyd35WO+Xsn8CoO6nQkt375IIXWFwvL2Z5BVPUiOv8Oj0+QwuO1VDqgQXU3aAiP
	G09XDeyROXXiqHOWSYOQvDIRvtYtgYY9HRDACrzuotEU0BLTbFKvDEIMUX0LiHUrYsW56G
	6Y+itYD4jW7alKI6Q4ddyo1ttYWcNsE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=VlM7DWeD;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794430579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzgw+taeENUOT3ZDyM1tex5SiMxNZDRD9mmmwBeUwBA=;
	b=BC/3zfprE5MlactZV9CeTLV2FFDB/Kt+6cU9IRex1k9oWOIr1F7GOGH0JDAqaOzaK5TzXT
	NqaH04IZK6/XTjqmoWporz8fnrE4+Si5DAyzvYp9/X+TkRkrGvj7LFCTG0q8sPS9yQCIcC
	C1cmycL5E7QO58OULHY+Ocgdba0QYDI=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4d581da0aaso400069866b.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1794430577; x=1795035377; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xzgw+taeENUOT3ZDyM1tex5SiMxNZDRD9mmmwBeUwBA=;
        b=VlM7DWeDMAd+L8P6eJZVnXlI9oJvtAsmJhFRGC9TK0AOt+gzu/CwqdpTTXgU0v7xE4
         X6ZMdko99KA73/iUO7E7pW42kgcnJxT//q3iZf873RPnJj17QvbJkH9tFkz7t1nnOTHP
         +Lytlt7C4UlLIFxCayql1StIB1EDXvmXoSyPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794430577; x=1795035377;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xzgw+taeENUOT3ZDyM1tex5SiMxNZDRD9mmmwBeUwBA=;
        b=1hdfB2IdaMtRLfbydeLWTs4uTE+u3DA4KGsIWZ4G32RiQe/qG46Uo50H2AkTM190AP
         yq/jeOV4kGfkH/s2rntGCMoHj/tQSm76VlMjfz0nB/oFK00Jgksd+oyXZnLPy/b7qHCt
         VJ+KJ7d7Lf1plqU4LDt6ki8So5alAQwKHH7tp/HVqxaves9fHy3wh3OVudCFsDFa8CUk
         C+wUVEw8Q2QtvHxiT/sGborNivuDJAWgSkiNB8Yl9hZXNcEa8ebV5z3hICFNXcElHy/s
         b38a46MnlRpMADL4zsn143YJuKvnZpDv2g52Dk/j97SDgAHGoMlm0ioA5dDLfi0MqHvL
         18eg==
X-Forwarded-Encrypted: i=1; AL+hErG4zby5fKsG+tJWDRyPS6XzNphqQEjoWSqPJPRcuUCaWJs5fa5SYreXNuVgmKbNqS515uS31qGBRA==@kvack.org
X-Gm-Message-State: APuU4Z9kwDWOPo0wrLjr8+uFPGytwexzYIrDA0Cqy7jBuJyyBMaV+082
	6XTf8oagy3xI9PwSXlRSmTS3v7rBAwnrNMv4PwGwTu//X4S/ONI6OzD2lBl56WCaucTz9uzaKaQ
	t065Q9dYmCA==
X-Gm-Gg: AYBFou0ot/Lr4ecwP/xFciR8P6ev8qOQhV9g2Ju8j0H3Py69i0j323oqX1ASpW7ypZ3
	Gog8ze4iktnkNxGL3evVau4H9kxnJ9yJbJF1v1so9AJbdpq0rq2KfYpNZZ0Cx3wMW0xQqR71Kbt
	7QEfg43EsU1bC5tSDcX2uckPbVnNLzgvsiUuzj65rzg9pGWG2j0Y6gwTX7i2Yt93KJ8cUweHWnm
	ROHe3VNxWCvOY7MTvGpQKZsTm/diK4cleCvnf7xv0zu5SQW5Otamqm7QVeGMEmk76k2nxQRm1jv
	YKLt0XgQmE3cvscEi0iFRP5U03GM2soJFjMR9GcQypF49l5ti8856T2xL54rfCflI+BYvJ7Kx5U
	b5aSPfMhx2bhyCmWpOI+jycT06/9thBgwq3SQ0uNHw8M+IHpjtCgafmitedPgMrVvNo/b79iSBo
	QpLAetyRU6ONoOKEWojV9zZa8okYo64FwgG1xupGDWLL3tdoRs3nAt9ngleQw0v0tIhJqQGJGz0
	xEcD1aiaFvvKI4FvHn/SOI1RDaBqfiTagwE/IGX0rCnExrLTnwPJhpFbhi6hHXr4E5zdzvtr1Fy
	aVQksMWztXUknziaN1rvaJ6FeDyOLIvYboRZKbcR2d49zf6rOVV4OP+X30b4D5n3BzpZf0PdV0k
	zSw==
X-Received: by 2002:a17:907:1c98:b0:c41:b94c:4539 with SMTP id a640c23a62f3a-c506698cf92mr254257566b.6.1794430577150;
        Wed, 11 Nov 2026 12:56:17 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7578d57c4sm2650978a12.18.2026.11.11.12.56.15
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 12:56:16 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b587591414so4184263a12.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErH8yp/ZGgqdDMJTA5eJp2xcd2PkXpsP5aj1YOSvSmkYNtp+hU6ZoPq20+8/JfF1DT9sNljLpP0Axg==@kvack.org
X-Received: by 2002:a05:6402:84c:b0:6b5:867c:879c with SMTP id
 4fb4d7f45d1cf-6b77780e6d0mr2757004a12.35.1794430575651; Wed, 11 Nov 2026
 12:56:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <606cae9e.bbec5.1a1c54f4f9f.Coremail.18670333770@163.com>
 <60541e98-b1f0-4f92-a155-8a29c0bb17dc@kernel.org> <44abb8ef-7711-4ad0-be9f-ca47206892a3@columbia.edu>
 <856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org> <avS5QcRj85yAm9ll@thinkstation>
 <71e24630-4c71-4518-a9b7-68cf3597ce80@kernel.org>
In-Reply-To: <71e24630-4c71-4518-a9b7-68cf3597ce80@kernel.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 11 Nov 2026 12:55:59 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh=cVrn+xs3fZiPW=kJbFQLwf_C+c-YBCR2K9s9aNE_1Q@mail.gmail.com>
X-Gm-Features: AclHuK-gqWa4UC85dpRfsS1fgVBckngemj92OtcgMmiJYVibB47wPOEx7bU3zC4
Message-ID: <CAHk-=wh=cVrn+xs3fZiPW=kJbFQLwf_C+c-YBCR2K9s9aNE_1Q@mail.gmail.com>
Subject: Re: [SECURITY] mm: khugepaged collapse_file() drops RWP PTE markers
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Tal Zussman <tz2294@columbia.edu>, n3rd <18670333770@163.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "ljs@kernel.org" <ljs@kernel.org>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	"peterx@redhat.com" <peterx@redhat.com>, "security@kernel.org" <security@kernel.org>, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gyjps9tfukcg1jfhruzom1yuxetpugwe
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FE06A0003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794430578-149111
X-HE-Meta: U2FsdGVkX18CuH37ym/QtYIKZQV+yr693MVb8qM/feBMaxQVfutaMM8970tm4ON4by2JfO6na0VXxKP+ces9+4SUumzEM+VHLU9tw97cgquCMNAAb2NR78rhjWHVnlQUDFoXoVB0l1OE9y2rHFA70X7FikCuDjTMrvI/eH13YaW/m8x4daXl1PTASHsB1QifQEhHXBwEKUe0OCCi/T1VifWO/zBiqhzuWsfRuPxLlZ/+DR8VGToGj/o7/vmcjzB9h+UnKhTlTfb+8g/OoIHD50fmMxTbLf9LQZQJSHCo07FUH+v1skRApGlq+x9cZKpsoVvq1X9/rx2+XTgXw/SrGdBuhPehlBffAjCQT5Ch3JSvKpGVaFMmx4RKwuSEiq4CgTM5wRSvmA9lBZaseIDaK7URP8vQORAIy30WEWToGoiOK/PqP1ISzBY5WkaLIePeJAmIPpRTevSFL705tA15OBkVbRgx9dweurViLZBK1znC08PYTRQC/qJm9atVzfPiCh3UuL2QNqA71cUMLjdd5u1cObsPcaOIIuKsbdadSc7eeltBylke/0JW5dPj9y982p9FrX+Z0b22F3x8c9dVat0x8bFaG26XG2tsent2Sc4jVqdCYoQ39tQrWPb5YpX5T1L2V3r6cf+Zl/01b45b7lqVj0vTy2H4+C3BbiYfJs9YfHsAPd9hZtGYuPU5mSlX69mbcC+KcM4bdnRyLK4fglAFlhTyWLYGjknIe2pZW4nmkgrXIXIgfrvGlyjyiBtGCossEqGnPz0D01LajkHpHtscCoXL31EWCJ45GkAO3fsQe2biio1C9G/PB2zSc94LUpS12+hXBA41obkEB/Dc0CMdANN7uiy15Ho+0XC9PkIZZVBMh5sqodN7jtIOjr4cZ8TuaVf/kr5j0Tg5TwRxKizUUnEW0QvJwWLdfTTU+js9fLF+vqcc8cIHoYExQ8TDsBGxDr6AFUnAuM355hH
 juebja4+
 PvWDp/evCPowhnv3U9EPwRAphGiw/ocrWdIgBhldEt/pprI79LgpsK9Ifwfh+13zNxcEz12+Pf5Q75JmlLnSyLN/nUb1xBpBM05dLRtDmhQfUV3WQYFsH/r3KqJnyYAP89dMRKsO/RiMTey2/X3miPhu6f0LWGsHn41kX0rcVPHq+QHtEvnN1yfBg3rTyX1SAmteTFV/u3vTNPp2XRYDjyW9hHsQV11lmdlWacs4QgLDC6yO7sgOYeOUjvexsQHFZjBmVzcSSGomLxiGsXfyN8AqsBS/QCOCRsegvSgnd9zWz27a75CgGDO1Mpm3uMeD0gc31Ve5AvYalRhfQ31nM7PwegbnRpsIj8u8EWjK5cKG3dEpDadRfiuPb/xCrr+92kUgIB4AqPhZ2kQ8LCSCpdRC+A5Hu2yWScrEvpukdz2pGs3fEz11RLeQICyZBpr2KgJUU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 at 12:20, David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> It would be a lot more consistent if we'd just add marker support. Or is there a
> good reason why that is explicitly not wanted?

Let's not help people do things that won't work on older kernels for
no real gain.

Is there an actual real-life user that would care and be enormously
helped by such a thing and it would increase performance or something?
That sounds very unlikely, since presumably re-faulting never happens
in practice, so just tracking it in user space is "free".

In the absence of some real load with a real argument for it, please
let's just document existing behavior to the fact that you need to
simply see the re-faulting of these things..

And let's document it in a way where the LLM's also see it and don't
think it's a mistake.

               Linus


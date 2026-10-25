Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43BB606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 19:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=owrwreaG
Received: by kanga.kvack.org (Postfix)
	id 5B5686B05B0; Sun, 25 Oct 2026 15:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566706B05B1; Sun, 25 Oct 2026 15:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C2E6B05B2; Sun, 25 Oct 2026 15:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B34A6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 15:01:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 929A916060E
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 19:01:22 +0000 (UTC)
X-FDA: 85362066804.16.51B8298
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id A4A94C0002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 19:01:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=owrwreaG;
	spf=pass (imf22.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792954880;
	b=a4B1kg1uC3Z9HR+R5gxncPN+ZTVbKsQlmS9cXBuE22+dsYcGznwr9AxG2D5vzjF7S4+P1g
	AEZhwvMXk0/CfgHwW0J8rKBQ3UxcrCkJAJJvAkA89HvI2L8Ie/Yky/qMA9FnqZ3MVTfd4r
	zSfx5kY1sjmOeEk7ajhWELLUvSq4WLw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=owrwreaG;
	spf=pass (imf22.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792954880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eep4GL9DCocomrU+bxRgX8heWYBDGizJAyovtrxi+A4=;
	b=GRkOKwAu09ilAxztbWrj75bgxe2SFXDR2q52un6mJyNEGeaS6wUYQ+xcfRXVJ9zIXYTMBp
	SV79e5K2uZW5l6yIz9lxlXhTG2YKcERyMUUUqcaY1ygxRk2JEAD4mdPmgxds+e6jSIndBl
	WEybAz1oK6H/rkwdW3T9/xRqPQU5CmA=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48df4e9d2d4so1309020f8f.3
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 12:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792954879; x=1793559679; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eep4GL9DCocomrU+bxRgX8heWYBDGizJAyovtrxi+A4=;
        b=owrwreaGumPCsHeOCe9agX//Yar3abPQkGD4dw2QvnKRwESJZE6ENzxbftQlV79zf7
         PeE/qA+c28t5eiTiz1HJqIo0w6PrbSnVvnv5f9B8sokTnpW0957TdQDhIxlt7yyAt3qs
         nm7icL7A3u+JgloIAeZHwE2Ge0fOVuIpRtExVZOR9z/lsAb22ggSXooDY8S8929fobna
         TGONr23auHyRY6/Oj0ouOLmFKMqv4MB8eRRUMQAmBvu1EJEDtGk+LRuaTJuKCABBzoi4
         ljEmTFzirxa6jHty/BGkqbQyluXx3f8ZyoSnv67D9ltJYSENNblOhvRTS28FVNTdEsfk
         VkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792954879; x=1793559679;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eep4GL9DCocomrU+bxRgX8heWYBDGizJAyovtrxi+A4=;
        b=cbPBWJR8rTRdtmgpkVVuXoChvDB6InsiYu9ImDYnqxWxeeNFnd+N7OuURJa/+DGjRd
         GqSeCdixqpZ8EI8vDuNz9O4r3ni8OGC9WHGCaYvGQSzso2ih99zPXZT32pSawDjpFT+3
         9ur7zZG/8eBaanEhW09CZlVtgBepVshvpi16xK7ty08K/CqzGGilBGkLY0U7RplAgDxQ
         iOJ3gUYvjT7JDp3lrceRQj78olPhJTI7bcswIlvYsCzYzKT/pUcOvao3S51nBCvJ9/BX
         fQVi5Z444FDD0BuLB5XnsQO10IaQZ1hex24uxLjpvm/jCAMx4vPpM/F7OlbtnMwRfLe/
         22qQ==
X-Forwarded-Encrypted: i=1; AKwUvBz7x6nBOep/7Kkz2FXcJIAtSv0msVL1+rtha5n4/4KxkktdQRu8OrLnC9SBptH/C2ZB2t4c+xRDnA==@kvack.org
X-Gm-Message-State: AFq9FYLYRX0B2sc85rcIUV9snVNK5Ws9PURSxuSu/Mpk2pK65jd1jQvN
	GVmapmGm3Zzo70Henl0Q9cHxzLOv0lgmAA8xrlEtQLqO3VElmnuQjQpl
X-Gm-Gg: AYBFou3s2wHVhmbajZc6+LBMkjL10EPxXOrqc3yhfcJzbE7lh8P1GsvNUlaZjbRttEA
	w0FMAnLSU/4OoAUWifiw5Ip7uBnwqQXOFVWDT4YK6mDVm871jNJOzBAmEgFKHl4K/wFlO5dfvjp
	frObdPeg4/MAJO8OlqH1xSb6pNoGphvmiI7X41kSGPVQU1f73sNy5N2qx4meotpOFjlSaKCC1hr
	fZxpMhe+WviC/V4iWSeTXShkl3pdSZAJWduvN+i76Crm2eREKW40sh9DpntMbXfSmkrXUYmukzg
	yM6iw/wKN8+H4qee7UPSOvq8DXl4IYqrej6gg9ixdwcwVrJwv8vrXgAfrPq1Xk9BtYGOcR7NKky
	+RkvWYT9LStAsMik9xolfMQyPUFLrL4Ers6iV7Gfx8tsTahnEK/HMd85kNFvdnXlXvHgbSNyR/H
	GV8EO1WsjX/qzPgOyZ0px/q0/pFBAv79ezdi26fcw2e5BszUIyR+HtsH64fW2lHLuhvmsteq6y0
	sAdci49bA7a2CvIXOiTJtp0cMnGLD3L/oCnacpsfYmtbOvvNNY=
X-Received: by 2002:a05:6000:310e:b0:48e:4300:c6d8 with SMTP id ffacd0b85a97d-48e4300c7aamr8195528f8f.35.1792954878913;
        Sun, 25 Oct 2026 12:01:18 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3bcdsm10026651f8f.13.2026.10.25.12.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 12:01:17 -0700 (PDT)
Message-ID: <533c4ef7-e008-4439-be40-1aa2a074dfd8@gmail.com>
Date: Sun, 25 Oct 2026 20:01:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
References: <20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q4ann6h5cutjhsnaob8j8urxf6hi4qii
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A4A94C0002
X-Rspam-User: 
X-HE-Tag: 1792954880-211109
X-HE-Meta: U2FsdGVkX19g6KOQEYoUpQqHyCepynmSVa3xDK7MAoXxUAUuVBTEcLFlqDsSwFVIs0IBcXqYT7UsSHiWQWiPj7F77QJSJz7fq2IqLtUoNE50zUfty9uDKUWLDPaOtsPQ+AEFF0BaoHoT3VPDVxAm0fJhgd8KWADw1wrGqfnhzNhsuCA+23nPG4JxwOoKXcWfnWAkYMIFAkDd5CjvGOGutDVTMeH2hVhUNX+FvDoXBbS0uQI2+miyHFaz1XD8EU/40qIUPS04cr1+6vbubEh4fHzg9htM0hBzVBSEqVuLkFEizvm/Gt1DAuBlLR8y7US1c0wYHsp9azUVyqRBvKrIino0+RUtlMOMA6qgEqWb5fQgz6S7We0gBnec6W8xUFbd920iExt7lzLbq3eHMx/CsTZDXb4GRLKOutc+92IWrc1WALJTazUCD0tu1oazmlnJywjgYlrUBYbG17UWJMWEvXZ7QscKoiYco/NNgQ/0Bz/K/2erL6HWyLBzOviQ/OmP9sAaP65SSWkFkDcqOE6mnR+a4ZIc19ABOJaiUZCzOJB1n8rnjBaUQE1dPyBY/2sC+0izvjqgakFBoxjZ6mG7gjskexHHGbNpxbSfQhRZ3+vSQ5/3xcxmwfyoY/X6n/iy9E+Y27/4q23KLGQ7XaWRvGBcTl7ZJVJv835jiQFfG0c0QnhkHUTkxp3K0mUMPlV03uwd/qvUQhWa9A07jHYVIX5UorBWjw9QG7HYwnhioSOAhfEzHnqOFiz3g/UvvwnP/TDkyxZQ4jJfd5BZoCwW8S4QTkNn0C9iuRMcAJr0kIrMCRG8yPeVpiN0/jKKEJb3L/s7OujNfxgCOw5PvSPOHmD15w3TBfB0VHkyAAFAv1LN+l0AjW714cTexQecx4eGlgxeierHUOClxJuqoO+VgJs+tb4nW9R90FgOqxUjLuxHGFZ4sPBlq3ygklZAODuut2yIWnA129tXTzKEQsx
 5BY5OBT0
 KexTvTFfegILlo6mLQoTdg0BQK9I6h1tSX1nG62hWXJXBMPRkQGodpuBFFP35dI1hhO85cHUD3SD3SvcCNlTILDpRNlAgI2bnsd1jDtFNz4rgk6bvZOLsFSIa4tCY51tywzT7lqwfoeJVLO8y1fHII1U6ADRqutFanx6zLMJ1euG6RWqT83Zo7NhhHKb3P5szQDNHBoJpCusNM617si19SkgPsb5n2OYcR7tUkeEGHQ/p24wHDsw/9EFWWCqheSk1CJ1DYd5Hfn1DNrJ2+NtFZj0ElBMkXO0BRy/MxnvIssZflPfEVEB1nAFzQlIh9wdAhUD9+uTiSq1qF+jUfJQ4zunGyioSd0S7TCGjIzS0kZpBUCRASETJzeRv/m4XFbCih9nH/iTZlDOFHXZ3i8wxg5Hn3RPPAyCQcCA/1cleTIVzIqdopJ5zUyDTyh3M5gSoAmKhTOenm/+gX/MJLA5+w9FC499v6wJQft+Or0gfmfPJKVdhatDAQ0npvjgwmXJij+7x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/25/26 11:43 AM, David Hildenbrand (Arm) wrote:
[snip]

> Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
> Fixes: ea3085dd7a4e ("fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} under per-vma lock")
> Fixes: 0e985559d72a ("proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock")

PROCMAP_QUERY does the same fresh lookup, shouldn't d9d1c2d81797
("fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under per-vma locks") be
here as well? (commit tracked down by an LLM)

[snip]

> There is the issue with seqcount overflows that Lorenzo is tackling. It
> probably interacts here as well? Likely, but that's an independent issue
> to resolve.

the saved seq is reset on every m_start() and query, so a wrap would
need 2^31 write locks inside one read() or ioctl, I don't think it
matters in practice :)

I tested it on x86_64 in qemu with KASAN, lockdep and DEBUG_VM on top of
mm-unstable, the maps holes I hit there are gone. Also, the code LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a


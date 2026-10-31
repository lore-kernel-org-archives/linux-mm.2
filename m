Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A021606A331
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JENMhMAU
Received: by kanga.kvack.org (Postfix)
	id B07F26B05B3; Sat, 31 Oct 2026 13:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91C96B05B5; Sat, 31 Oct 2026 13:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9591E6B05B6; Sat, 31 Oct 2026 13:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1EB6B05B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 13:29:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCB1F1407BA
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:29:42 +0000 (UTC)
X-FDA: 85383608604.02.D43FBCF
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0EABEC0006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:29:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JENMhMAU;
	spf=pass (imf28.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793467781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwRF56TcOm8rFLCnqU2JxOydhmu46zMDXK5qAXpa48g=;
	b=RfS78NFdA13/bwGM+2R2hCXyMFzQLbFn1JXwrn7dq9F1eqtHnsnqD5NT93PwDNYtbvUREj
	vXKSA9gucFn+3kbt7DvSn15cV2K4xphEtzobdooadAPUkZSGA/a5AklCwlr9VM5l+EAggI
	TOXhBzyzxNMuI9d9NqKL5iAGzhjaI38=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JENMhMAU;
	spf=pass (imf28.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793467781;
	b=xkDUJDzwCQJgTchErRjOXf4vW66UkevP0GQYOPyhEupdu2HVfL/bLexg72YCkD+EC16Crl
	7fLXQTvQVMznHvsSXlyLcOUjd19UjbR3D4aoeU5ktj2bMVLDuisjJH5yyJsnGcJenYZYjm
	kCmwdjtJL+/GQco5vZv/nHtbqQEYRRI=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso17854425e9.3
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793467779; x=1794072579; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RwRF56TcOm8rFLCnqU2JxOydhmu46zMDXK5qAXpa48g=;
        b=JENMhMAUddhO9L7Dgpyvk287DmsC8S66cEhIU7dRlNGffxoU8KZPy2OuWGAKI3cpx0
         /vDZ8XRXfSzvsgG5g/GT9nViht10nc6eO4Joi9aRfWu0R3R/2Q58cf7utRMYZIuOHAR0
         qq0wdYlxexFxdig0LsVEpROe8JZMw+2Y9id+y8S0mf/sBkVMB3/bqqs38KfVZY9yoAPL
         8BjgWwX2XTf6NrftcRdUYJxMITMx+A6w8yxesIAnM5LInyBl1WIfz5lQTB/77/FyVe9N
         Iv2chwoWKwAfcowt5p7GWQ9f8uk7d15IYxKC9Ol1au1V6efGpbKpiyKhnaiJDHy0AwAr
         zHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793467779; x=1794072579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RwRF56TcOm8rFLCnqU2JxOydhmu46zMDXK5qAXpa48g=;
        b=mK1j4Xgxk6l0mHspUKLaRNPFEgYVcqFlgNrdS3WxMhE31jak+HnyqyjWClgsQj8WD6
         QaXhY49UUIa/5P7e72d0K9gxGfQqFXlSeCn5Ny5IxLbLh0vdDn0muSEy9y5t2vDetDkm
         BbIlmkOx2fAHiCuL73yACgKLZbcKlmZMskXjrT38ZpwXZGEf8wc3JHANMh8tC0rfZj/s
         A/L0fj3Imub54aAe1qCEMWGrf4We0SRwXRpDYJosWWNsVri5LPJPrDWmW1GjkEO+F7RP
         I+fSlZS2qjRxn72JK/HpwaCNEHQb1X8cPBq0hrcj8/teXz6N+sZpWKlop6XYmggWQyq0
         y5uA==
X-Forwarded-Encrypted: i=1; AKwUvBxKqSV3aBe6e6TMwoUIWyWRtsQPgq724xzcjxeECuEOeiqUa+pNG9V8MmGYSIzQTzb+6xUaNVKm/g==@kvack.org
X-Gm-Message-State: AFq9FYKx70ZsxyxlkY2N/ZzFZTLkbc4EwyMxWNKXVWamZ+J0mz93bJZb
	gXcherl0jsnAvglI44lY2H1OqRxIjAFo13b3SNZKT+WWRwzHQm66w1Vl
X-Gm-Gg: AYBFou0HRWlfTQUx2xqH2DwFfEYaWnJp/b2aBTQwMte0+b3ebpXItn2pNspBlqm6Jvq
	TZW6yzb0wMuyg878XmqzF1oQ23bX5n3Mwx/UwKgzR0BAPmn8XmR/DB9oyxdWhBeKJAYNNbroTxF
	aorS/jry8z3EywRSreFU+EBvH2v89aOhnbRipwknEBRP17oSQeAFQVHDXd27yL2sHloN0xYmAFu
	yXCsxr3uJlTwm9uXd7Ezxj+JUSWFybFFb7bu6h7NpzdNgi48/cdjJTm9svxgBMZTAD9ejO4Daae
	hm3tlsli67jIfXIj10JoW2cm1fNYwDoNO1CcZ2EBRYlj0q0KYXHtsBOIHOuIDtqyanQo9HOG9Ox
	PvN2c1HJTLA4Cg4dajJt1tjNcz62gekcQtHqNjF7KfRe1tDiLg9e2AxZ3USo7FYYCr26S/5E3X6
	4FnBVVBVhFADfkEMP37RJmwp4Ie0oSOXyfchPNpdBaxphQIZcijmRFPNXDAGanGxmEGuBJSWfGX
	ys47lVlZtFD8CYLfDZF2G6heqrrB9ypk5ywisIafaeUkqFa7SWpEQLuWPUildTNhyZt/G0PodQl
	qBMeJb98RD6cnjLVa1NQFIEXeBSroNO63NpQXE24e3ZikaKsFB59dfSU992F3vtt3zkBnfWkEEF
	4ph2Y3B7f7SueFf3H/KTFkhLn/Rwv81bHUvIya9mSVz1YaonVkFRK7Kkz2hKGgjxQxVyLe8yCU7
	nQHWnuo8GWXeoIXVzcApYt/DkfCW2hqJc=
X-Received: by 2002:a05:600c:8b63:b0:49d:34:420d with SMTP id 5b1f17b1804b1-4ac17ff9d41mr121811015e9.20.1793467779294;
        Sat, 31 Oct 2026 10:29:39 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a81d-e001-9c9b-db33-f166-0fda.310.pool.telefonica.de. [2a02:3100:a81d:e001:9c9b:db33:f166:fda])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7c5063e3sm212352935e9.0.2026.10.31.10.29.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 31 Oct 2026 10:29:38 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Waterman <andrew@sifive.com>,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] riscv: mm: Skip the icache flush for special PTEs
Date: Sat, 31 Oct 2026 18:29:30 +0100
Message-Id: <20261031172930.835-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261017013634.792220-1-nickolai@csail.mit.edu>
References: <20261017013634.792220-1-nickolai@csail.mit.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0EABEC0006
X-Stat-Signature: bmbeedw73r9rqokacp7nnonw7jj4tcpk
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793467780-124139
X-HE-Meta: U2FsdGVkX18hw1rqXOrpn3cN02B/vFSpjhsQV6SiGibVxppwirmHIP30fniSufd98n7is1ex6G9saj/iYFRgypM0egKrl6W29fRpeDLiIrnh1ycZOqnmotzSKpomAhaU8QZKu5BLvSrUMeRzqQ588xyuYvAoWG3Wnf+6WyKVOsfvZtrKroFrKDKgFh/JK+cJroSE7lyKWX5JV5wkofZSSlZznVpB44+pp2QCFNmult6KltYIH7zFh3Pwz1DtMlyXrONIHIvuT/mOXaqKlJncwvDWUgAmHf1oiV+fEputmJrDS41rzgaP/q7Vb2h8N8RUmfc9UGe5mMQ5k/BLdKXfN6ME6L46x7gdnxpf3q+Z/M18B494oezJJJzCq5vKbnbNRAcaOzeoFipIKnCH/SD0HSoJo/cuwkEJCZZbZ5l2ilmImnY1idFekVLy54ioTv3rynjbz7xmpbY4XLBLQSUPq4cx4DKRkQ2mcqRdCjz5VtA8LOyIFg25LWJ8tngm9IFVc2MTR/QFTmyr5/Dv7xjkAreaW4+6VWfPmX9QW46ckif9ipBBdObanp//EnggR56SB7EOjJhBieRYd3IM0QoAsgbozDhfeG3HQUIYJcLLYnxTm+ifGViNCg/F1DKyfl0YjrF5ZXhfqz5H2A5FGXHB3y7hr1h9fSEB+OZe03mhjcIK2VOFvSeEAFkh53J4GPGNJLz42cnyuSrMXAVwVWjbS2Vxiwys1d4kPYRiYqsboXNorLe9MFaEaQdD5qwIs33e6xV9hKizIORulkb0m1pmvSAkEqJUVinPjCctFy9qZ2GsW0tUY2gMA/DgM4DGMeXMG7P+cdRSpkHBja5vvlvBYzDo4T1XR9n3uDKSMtlCOYWeXILfSossAkDFbTNwhmuBzVJzpDkVc1+LxregCmrSjrFhK2KPEdrz6T/CbzjBHdK2kcoqllWVh8CXoCD2nvhn/opp5HKmBzd78FmJ0D1
 Yz7yCUgg
 hVKr0UMYi9UTwrUx6pdgP9iKDZg3IhEamnZsVCXu2t/l07zG5uxZGtZFEyhOFGFV6s5a2HAyRlMLHJNntn32gwezuY+w82LnRBxh8Y5JVt+Oy6HefW9ph4Pb+oGnTe2DxMxvA+ekwNnAaUBY/ML9a/wBMnamK8lTSeg7wAaz2W3Gs+7YXYWnAsxy1TUqvPwW3Tc0tpJr6oqs6q6IYkjDeu+Qj2cuv0C6GlkW1Eo36RYPAgHmKBow5zoPu3cN8ENPz5VQLbvc/8OzRStHJRPVBjW6OgGbo2Ev8YPZhFzTOg0dbpwXTQKDBs+ZcAg7SIMkVAV826rCHltgZwelrpBI42VSNpI9GWqtKVurJaJzpb6DipID2xzy11n9her0dQvciWmabjwyNkvUsWIZUnenqjv5D+hxdVEIbN+wxXayCwoED9veIP1hkF/gcnSUv2TZZGUtQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 09:36:34PM -0400, Nickolai Zeldovich wrote:
> Mapping device memory executable crashes the kernel: an mmap() with
> PROT_EXEC of a physical range outside RAM, from /dev/mem, from a PCI
> BAR's sysfs resource file, from a frame buffer or from any driver whose
> mmap() uses remap_pfn_range(), io_remap_pfn_range() or vmf_insert_pfn(),
> oopses in flush_icache_pte() with the page table lock held

I hit the same oops on QEMU virt with an executable /dev/mem mapping of
0x200000, which is unassigned there. The kernel was abf8c33470f7 with
riscv64 defconfig and OpenSBI v1.8.1. The mmap() oopses in
flush_icache_pte() called from do_remap_pfn_range(), and init dies.

With this patch the mapping succeeds. Loads, stores and instruction
fetches through it raise access faults, which reach user space as
SIGSEGV.

Tested-by: Karl Mehltretter <kmehltretter@gmail.com>

Thanks,
Karl


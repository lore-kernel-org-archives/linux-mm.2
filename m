Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F168C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6CD6B008A; Wed, 22 Jul 2026 23:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAED16B0093; Wed, 22 Jul 2026 23:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D376B0096; Wed, 22 Jul 2026 23:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74FCA6B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:52:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC570A1014
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:36 +0000 (UTC)
X-FDA: 85018669512.30.21727D0
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 271BF40007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RMr/LaF4";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784778755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUKG7ICgd+GcU998vdcK6dX06k2jTdeBQRHxEC1Ia7Q=;
	b=u43L0CuKDziF/3REomveKKcq79hfA5fju9GVVIiMRCwIewT+TyHSN8vmGJxbobGx6M0vOk
	H/9yjLYQ97Gtus3pOhRBW9BSzuo7FLm7YhTxoRJa8oCuiJzX+pMOcU+MXe4jQpWx4+ZdPe
	pTOlOgVcGi7RnuqCfsxig9emm//DFn8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RMr/LaF4";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784778755;
	b=Ji65PzuZpO2EacUmETADro95sYAgq/RI1XtrHJ4LiLgE7u0HuTzxfbju0HW3+VqnulxncA
	xuMrXM50aVCZGRS+GWwwPB6hKYVvRI6/f2XmzDrG1/YQzZqK4c1InNQvH9mVnRZPAP+/I0
	yBker1O+LNQueSI4Rf9lKHwT5WQmkT8=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38e07ebd263so123112a91.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784778754; x=1785383554; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FUKG7ICgd+GcU998vdcK6dX06k2jTdeBQRHxEC1Ia7Q=;
        b=RMr/LaF4Ic9auEq6m88OR+hQE0xI+MyGTpEClvDsOKzZ9nefk0i4I+Pzj+t6qTXO72
         mIEBJ4utotk4vhJPYtyi3WIikfLWc7PeQgT+uOFYLn7+Au0+w9qEu/SkXu9W3+1P7MmT
         I+0H6HYdUZD0TfRHHh2iiunuzGpRdn1rvk01cb2mYcxVdw0IEiER0Zexq7t8ZWfcNUbz
         Y7Q+uo2aSQI95fxy4/tmecrlP/2tXLfspkp37zth08aXC5T+u/PygbZ3H6vZ7c9MKNNh
         dBT4k+xxT1iW5oLufjhFz/JQFZCerDQ0lS39+NOTD/zmDm88grdAZ8QROyFickQ8ScP/
         c2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784778754; x=1785383554;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FUKG7ICgd+GcU998vdcK6dX06k2jTdeBQRHxEC1Ia7Q=;
        b=XanQDwFw+t+AVp5UgHgilKZYotK467DbxPanml0uFRAnGuSweW+/xuAgGynWKLazQf
         W5CuyCnQpl1arnIybstPF49KdQmgnCLJgcKPX3b9e/pE0hgmL0FAjLyYCBNMXuFHRFBh
         H4HFoJ5i2sIt9+QbmEG5di8AYD2F2XtPyD5sKcjyasFlT9xIYm3+EPiWrRXP0izKY9fW
         srSiqDcN4i/QvboTCzuLiRsxAXmltT1cUmfHowbEVMkPQzZTlJf/yITMUzuMIpcFjpuB
         RBR3ScbeExEWfas85VqaUAVP88aXDcLNPiIgdFKStv+DJ5MfobUHo78W/VXbrwgpQYxn
         eZEw==
X-Forwarded-Encrypted: i=1; AHgh+RrcCW5mgc05pqJIm27dYjEdlyTTQ36rj620AWrt40Tqat7IxvELlT/pZ2GW9MTinqGjoSCdCAy37A==@kvack.org
X-Gm-Message-State: AOJu0Yw3D0dWJ/g4o4Z0hyBOnb6MY+Pv7PC6WAj3Q4DSFzObH2k3+yv2
	dgJgMfS2zp2oFb5mC7t9iR3QgdCPtWXGpaK5VNsybiAeEGWqNemLANlyF+VKJttc
X-Gm-Gg: AR+sD10cGebka5NTuJTCUhkhTydOVexr04BUh3sdx2O08kgZF+vyLbHXu/UDsuBbJGA
	drUDDXB+LWn3nvPe5APDWvfVVBolKWq0Q3JDNacPFSjcPnVnUNN7YqAP7sHE2NNCtAiWmkMM4ck
	Om9sCZurWhLYi75QkLw7ea8ger6dVCuILhhfei5XL2Mfx+Bim6g6fMy1Kngt4Et+IfuVpdFSpM8
	SEMxhdWW3zrbnYntGqPz6f3BRd+IHZ6D0eptDLgSTuT78p/oKJSeerRT0hxdF5svOvDGeSMlr/a
	3lVxrNS/8o9sURpFjPcV88H6cYU6Lqi5tEWuZaoAJPGRo6QRBM++F5LkegrW1LvvqV1Akz4R8C4
	yyCkzMGKbrDjDmEvbbsBYlrX+9BFx4/oUhfW3mdtcFWmuu1tRMZ7jo9dz1KMTdCdWGZvCNsq+PC
	MqCyRflwprmRFmTbud
X-Received: by 2002:a17:90b:5650:b0:38e:cb1:8ec9 with SMTP id 98e67ed59e1d1-38ec661b520mr1404913a91.42.1784778753914;
        Wed, 22 Jul 2026 20:52:33 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d12f267fdsm11497359c88.0.2026.07.22.20.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 20:52:33 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 00/21] binfmt_misc: transparent interpreters and
 PT_INTERP loader substitution
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
Date: Wed, 22 Jul 2026 20:52:07 -0700
Message-Id: <178477872729.254289.15918342296936455606.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 271BF40007
X-Rspam-User: 
X-Stat-Signature: udmm13mhbcb64qihqoakh3ngey48iqdf
X-HE-Tag: 1784778755-132864
X-HE-Meta: U2FsdGVkX18GWFSPmpSvlTcUqzFYDzk1Vd3sAoRPekHMzc9VewVBAv6OtIU/tao1XFnRmIAhbt2+xMt0FTeYfaNrMTnE1WGnrC1SgplaKV+BXn46xrcvKfSZLPTorAhJ8ua7l7HJ1o9z0tMcAdnDg4VWhYzpPAq2Tsqo5HGONNbWjY7qHFUbwmbBitRIBjGgt2g/Gt8THv4sBlzKmqmwpSuuxy6RJUjhlwWOe8HYVa0j5hw4GPh3wa0ehaV4jp+QhAokKyr9OwlybAxWKq6U0WF+85a/qDuauMb0m2NYDuFsabxfIqJB+1PgQ2Ys6hcB+i2L291dtW5uhQlrOiSzgFTOC6zTAXuSElVL59Gg8BkppkOEC13+Q7WKYyx1KGxkvlRJp8hmUPPDnzdxay3KVBGssgrmDgnP/bvKPzDFsSKS7J8yH6QzHQ8tlIaNT/cF6scUlcOipOB5hr9nY7DnG41jVph72zRISDpvVQjjKSEF3igBW9319CyrNnGfzUP4z06yWBLy0CvcL0reWXQ2OWgvSxYbFWdUb1NH7A1itwjG4K9sHbljz2hk24eXhOK7ZcT+QokHLye3a2XGiXIhRKWUax8kiVIkGrsRti4txEptAG9/aRNUH1NQzyDEtXU+0cc8FBj+OTksebSUmqV00lsm3PknmcC/+mU9/In/AJbUkfJW10k7SMQ46ctZai1XVhz/6ctf4uLGwkF2LRrdttmuXiI+yIkX3ijagE0KRuGKWeZsSfxLWCR7NISpHKvCAFQKwq/4EMq7HQdOljl4qspv/Ocm62/q6mOCbTpK1u0SrhR+KtfDfVV/SmkR8J7l1hd/X5qywZa8ItPrc5/9HnHX8Kky6ytSx4j39tDWZrkkIydMbCiKNy7ybyiWgPBZlvXZ6xf3m+J4k37pYDlmLf3bysJ4+Dv0wGRL1xeGZLXmxDSD2rPypaSYWdg+k/us4Q8KdHoj53B50n9hhDH
 bJG3+afb
 oIAGZ3bnjOLy7TaZcST3HAr9WTdk4Axm6SsJAX9c2TijXZe9lp9p6L6F5fxlLAFHR+Dfd9gqEZ4xB2zTfGlidGzkU3+hNALFBJY6yJ3UlzDzdbvztZROx+1+cZR4M2qs6ruLK4xdLJHXexol8kZOu4ayB1hNI4vrR6CSXOuAiZ+UYJIQW+CxNPsdAcKum+YSGSlf/YPjQ5uyqyHHFlUcN0HheY831q6E+pLVXkDKu3evyykVwNveSwtDPaeoo2bv5tZFralrvfA6wqqc/9V7KwKDx555+xW3BhofX2Wv67bFKnj+Orz2zK2qIuWDoox3o54/UXBVdZmXBwe09qjQl+PFDeUny8pWKH/pp+oNCPSuCjpsk3e3KXEfu8SBfbAv9/8IEqGT5P9IhmP91ShoJ5gOIpcdvcFfRy5p5uB1LmqBj3G6ngCtgLaJuRW3BQR1A5r6YTPN91no/UuaZMAn0rt38OX7d+3axCUAZm3vD+PrLwWMUThZHfNJkhSkt7OdyS2zlZZjtMg7FndSYU96GzTva671nsckfzy/2RnvW1oz4tjY6TXKlqUe/5SL9O9kRu1pd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 16:13:42 +0200, Christian Brauner <brauner@kernel.org> wrote:
> [...]
>  tools/testing/selftests/exec/loader.bpf.c          |  56 ++++
>  tools/testing/selftests/exec/transparent.bpf.c     |  57 ++++
>  19 files changed, 1823 insertions(+), 303 deletions(-)
> ---
> base-commit: 6cea93ff6fe97df34b63fe94487473e16c73b74b
> change-id: 20260719-work-bpf-binfmt_misc-ptinterp-e6ee99ff6ba8

Started to review (slowly); looks like the first ~10 are mostly NFC / refactor
/ documentation.

This b4 thing is so slick; I want something like this for GitHub now.

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>


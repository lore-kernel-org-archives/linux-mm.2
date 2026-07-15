Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D185C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 00:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 261946B0098; Tue, 14 Jul 2026 20:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151736B0099; Tue, 14 Jul 2026 20:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 065D16B009B; Tue, 14 Jul 2026 20:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD21E6B0098
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:29:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32A408050A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:29:01 +0000 (UTC)
X-FDA: 84989126082.29.AF78A69
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id 504BA40007
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:28:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=La6Sdi1Z;
	spf=pass (imf12.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784075339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajpIRi7O5d8LXEs8HVy9pi3Mo9jVPVsznVYgyaXs1BM=;
	b=fkKtea0zsqp29z4Mc2uUdBA1TCvufz+bHLALEKys4WTCfIugPuSzUNYdQ51xZF0hjKqbrm
	P0Y3siKHdgJSYT9d2yOtJF2PEzydg9TAmkSUG8ympmrXEKstD3Uxf2vdFwLKdjbE4YWqnq
	wy9NJGb3hx67U7IertoCFmj5voAcXoE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=La6Sdi1Z;
	spf=pass (imf12.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784075339;
	b=OqgT3PQLESdMaPMs41wE4uWSIuHzjFBqPUg6Y+ftmU3bBaNTMeo/1nYFTiUuXTFlPlJB5I
	vmRroydX3FZs3VBhsIjukOMmRaU7CoecS7QuimvyxfTrRSBkyKBvCWaJLn47Dv3IUOg5cU
	D+Jh4sq3dc+c/oD9E1IzofM8GDzzdng=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-383cb94f742so4518060a91.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784075338; x=1784680138; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ajpIRi7O5d8LXEs8HVy9pi3Mo9jVPVsznVYgyaXs1BM=;
        b=La6Sdi1Z/Ca/yqSt3RkzbOqw7+zU4UdhG1DDRbr8wy7a7yuBziIj3fo4k/Q28xhAkC
         eZV0GKNatr5zg994bPKFNSgNtk0vBp4Ckn5U6opEh9+69Yppz08HTGPiVqdoFjWwd8Dl
         OjoR7RO2W3lA79WWqcQ3UjtZoF+EWU+1X+T3HAhOa3gnwrF+xbPmq/8daIK72z6QeITt
         M9NuyXJcLQK7fw6BOUHzfKDk1P+DHtd03QXnfbLTbqoqK/mb82k+dmbk8ZY4jfrFYOXg
         N8m7lDmOz+Jd8qHt8VtN6H/9koNmmJAHYqwtgBWUql1Spa1ONDWUOOs1PFt0FvYprBx9
         rKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784075338; x=1784680138;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ajpIRi7O5d8LXEs8HVy9pi3Mo9jVPVsznVYgyaXs1BM=;
        b=JdRCJc4OS2o57FwaXT8XknS0Eav/Sk2sgsWuu7rcyipqJk9i6ZZSNFAk8e3iacTb85
         5AW1AmwPVfdM2BuHKNREj793qUjkfXeMsz0FnJATOi5f2iYWCPz+LyTrLjj9KVbFn5c4
         /24wj0LiWujAZY7boKrx9HtOdz+awhfh6St2eVdbBUnFnw9EX6sH1W6beGA7CQNL/WRP
         yIdHUJ0qEQVHhHUBJdlLKniZBwz9C2fCoSLJilzYDAlLRNrBAtmCNDDh4iSALipAkZGY
         1w4RLIRONCx8K9eGVjdvJi/9C/mLuqklNTpjgrvVQkSwlZra2vkRwofwN7g0OxBC3LvZ
         HZSQ==
X-Forwarded-Encrypted: i=1; AHgh+RoYafd2klhUHPJHHy0Uni6PJnAWdKNzJQTNiF/BkzFMin6vQqfbnw7vPy0UI9HPc6aLC96TbYiVaw==@kvack.org
X-Gm-Message-State: AOJu0Yz1eriUAkaLeqSVwiT9mTv3F4tIKVlX/49qEyNSvh2ztdl/OmOX
	Y0EhKNCgA6molsa8SLq/HtzDuThtACyyt9hbpjbPRlCykBRWmB7Awb1m
X-Gm-Gg: AfdE7ckv8dlU8OqqhdvpuA4Pj5JNk3s1uHFs77qdoX/F+EcuL2GCS6QWXDk5/Th6qLQ
	/MYEfOpB9LzlYccR2fd16GPYPr4lZThbKtFnmp/xKAHzwQfSiN3nOlVB6JVtV2MMFnA/cWlD0HJ
	nOnJ8OZg91by103ywULlPhUfapHatkCRde6OjfwlWPGo/GDoAO4rBaQe+YMutOucvCn3zvUPQaA
	xDX4XoYMEvaTccRqyWB2/6eIqpkD0uRf0UyLUsT6GKpcLDKVE/ZUPsn+JRYITU2l0vBFiNLwQtZ
	89LyVq3zenZdIbvPbybeml5kbhNZFCV8rbLkZPTvlxy53gLeqek14LqaNJDn62/XUiB8FeLbeLs
	eDfyxelUtqJi7Q2zerS88BLeoI4nlHVuvV5PI61b1nBhpVddp0oQfvUfL1nJRnXRH3X+5C5rDzW
	DrpaX6u1bfVYhkcyKt
X-Received: by 2002:a17:90b:55cc:b0:381:22d6:f7a3 with SMTP id 98e67ed59e1d1-38e2a030362mr682173a91.18.1784075338228;
        Tue, 14 Jul 2026 17:28:58 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm86075098eec.18.2026.07.14.17.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 17:28:57 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 6/9] binfmt_misc: let bpf handlers pass an argument
 to the interpreter
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260714-work-bpf-binfmt_misc-v2-6-57b7529c002c@kernel.org>
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
 <20260714-work-bpf-binfmt_misc-v2-6-57b7529c002c@kernel.org>
Date: Tue, 14 Jul 2026 17:28:38 -0700
Message-Id: <178407531872.2243172.4159451666378990368.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 504BA40007
X-Stat-Signature: j3fz5rs14sez4wu87zmw7eifc65sr8ze
X-HE-Tag: 1784075339-15845
X-HE-Meta: U2FsdGVkX1/mr1Zxq4xQs4Puv2vJ4u+zD83TZ4GHWmhstPqbEVCQLYwvBV7VPHklPwKhxJ/f530eJ8RrBUgKoijvIgXOsW3rlbWiZ+eWto02e39FbqxHnD8iH7F3pJFCnWwbGJ6IPv3i62Nw8SrjWiKRHrsO84LdwZ7IJWkXqV64bI5Tkj0qCCAKmI5tQdqgz726qds5Htw5M3LA3YFKBhZULay0hcy0OEBtrsxQS4JEj4QesbX0wIjixZ4WshedMuLzbDwdo05ivAKu4VI/LvUu7XZaXp14pKzLwpNLbxeKwYJPUrXEwsSEtHrd+rimpDY+UEKrQFTsjnxojCfW+6YWDUmkuqStUgrzSD+d0CPX6vExVL5obTFqlkMXQE+HAahPYtsv8VlEp5AFEAC1MSXv5MWSygbR1n1CNvY22lHRgqxq7UA4CdHAU0WcjRYs+gAFWB2OdWszioSzJ+d/NAEpC5432GCPMWRQWPzRGU5PDOIlcw5PPRJO/r8vTSBfNvaFi43MVSZ0zwP5X3z4AYRTrdI93dAPYvJNRLXgoZzzXew0cxs96jqPUeNLG4Y0ZO8X7RYTa2zWuxlxkEa47c5GVk76uFlLJlCGXd5jS0SedF96G1bPfzXxikaQrjoT0sN97cg2gJ82tPhUFLhICBNpP2eyLqqCpZA4ei967l8bF0dUyq3mZKsQyz/mlo9bQ9t+2YvB21w1bMC+/qkreOT6f72ZrOrzgnURkI/cpPh6peocJleDnQa22dQtEKbVgpiHLrfFRNNvtGmY7uoMseCrrrGsAhyH4xBaG/zWzJmoktH4J5UyDKFLXa0iC5QJQx6Nss9l6CeUhFU/ET0VLnTzC345GeeUkJQJA52Lxl2lWP9/GZYRkZjxtbyIcJ5CTdjbwyCFGl6W6qgB/9O5DKrsTrFv6wtLlaMoM7PwbzHVkJhgY8+//HLMgc95QsZYH0dAHCUGH8j6Y6gR1BL
 RckiNX3e
 wH8yckFu9aoKl4SqMiMorGzUc+NIHByXPz/YHiUjH1gCBN5eHrJFERUzltijNwMKbKkW07NVksKA6teKmG5jeCQn4f7dXdTwD0qxDx6eWo4dQSfN82+SeqBIrc2HEkgkT5MbwZ1jw/rt0V6RuiC/kLkCJgZZOl9MwaCqeKg3WVdvaOS+tcrcR+uWVEIlD0TfJnGf1Q3H3ubdbtkWFnsx78QNVnsG5oAiAgg9R++nR0jILdfbl6Ule/MT7xZcxDurWV91Klv73emAND4anMMNp4roN/0HXxVWJsG8oRHrPh4EypXWVkEbyhhIYB7cUo70lyTDJh8xiL0xUAQw/pMD4v1yqFcxHaft0pDHMeg09im3Cdr57KTJoe+ZgOkPJKBp8bQVXiRd/bnla8F/JYzHV12xAMyOoSlUZYoNQSaZtR7GkBCy9OWxJOGh6aXl3dTtQ4e+Qr275ILyD7aDLQaaDgvEJJkwx2Y445oXrl9QeDUbKQH928Jb1fOgR/hyNLzRF+kaAJHDzCQiGn41xllVuX1gk+AECrARDegYr8yJyIHwxmNAxvRF/5+t0fdKm8p/47U5i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 21:58:11 +0200, Christian Brauner <brauner@kernel.org> wrote:
> A bpf binfmt_misc handler selects an interpreter but, unlike binfmt_script,
> load_misc_binary() builds the argument vector as just [interpreter, binary,
> ...] with no slot for an argument to the interpreter. A handler that wants
> to reproduce a #! line therefore cannot express its single optional
> argument, e.g. a handler that resolves $ORIGIN in a script's #! path loses
> the argument that followed the interpreter.
> 
> [...]

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>


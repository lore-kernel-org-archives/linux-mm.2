Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65211C4450B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 00:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBF706B0095; Tue, 14 Jul 2026 20:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E975F6B0096; Tue, 14 Jul 2026 20:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACE06B0098; Tue, 14 Jul 2026 20:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADE856B0095
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:29:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3AC16401E1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:29:00 +0000 (UTC)
X-FDA: 84989126040.04.45B409D
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5CA5740007
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:28:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CRck9rmp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784075338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nfsPSoEu0xJfM3sfM8gGgAEUP6nwZ6n8ooDYgwCJHw=;
	b=poeI2/hlFbUX0eGtokA0gsqPZTOMod3JgVsDsWylTc39OPh/VxgaaAgEiEO9mQtvIyJtNl
	ZL3D08rtdlgUQmCpypd+d4IDPHsHQbMEQcmm+178iZ/3tztzqDkpohu0cDOfXZvPouQovT
	YTsWmsrli0LF562eFeslZuvMkCk02RY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CRck9rmp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784075338;
	b=ZTOUzaWdSDsoIagcCKB5hTn0gycyGm/OSj/NtzDulAaUn4CDuE9k7IhfN12zlYXpIsrrEP
	jHYuBLg78aydGUEcbx7FUxvqKfUSvlYXJZxdPiwmneHbJCUWEVfgt39SWb2ZWZ6KQsdGH+
	suMkaX0cbNOrvd2BQQIpuu+4K6od7AQ=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3847e8b0f3aso4047139a91.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784075337; x=1784680137; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4nfsPSoEu0xJfM3sfM8gGgAEUP6nwZ6n8ooDYgwCJHw=;
        b=CRck9rmp+yqIckmMHQu7zUpgeoqJXpqrXFyl5o12zHcmCr5QKKHzLMewfOn7Wk1tCF
         MreIU2zIU20QqGFxElERo2mIF510O/iB+sXyhtOhf5t5XQ67zFyeSuvYTBn6nHQIS5R2
         tZnQk0B4CSt+qTEyykK6F2lHUX5aaDkIOCRFbPD58gNWpWpCzXT7sTsDuwKtfuJl/ysl
         yMoQo4fUGBmgYY3fFgXTkIwjNc7JoyL6SYXHIKAJO0TqM+PrS88aygh4KyIO0ui1fUDr
         Av1ZywmqNaNt8CEmCFVQkgsEPfHnQZUU8MkSfwCFFTjstnPP5VuLHWVnl9AwDxaneDQQ
         XYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784075337; x=1784680137;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4nfsPSoEu0xJfM3sfM8gGgAEUP6nwZ6n8ooDYgwCJHw=;
        b=SArq1aJyvefIQj0fwZiBcS6TsU082olop48MlIZUKx0mUXHQm3EEzfyA2lpzuD+ylT
         /TkrvG3svcVUWbZd+0g+CT6Q2atwiIKJpvqgjxAcOO4giXTJj7BR+hW5/cGQ3jRq6nxA
         oMhC9gW5QdypLPHOm3N0NtnCNrVCPIm4oVzTN5aajz3y0sGZlDNRQU65p+lFxWhiO9z6
         AhwhNBLIq5neeQTtF8ye0X4nkvWFwGncrzRCR0Kfd5c1qReUJmMei2r9hU4nqsJOTYsD
         V177Pog6CakLMYHyAavAzRnc+WGDU1zbHSHF6PA+bumUSJ+j8VtWiGjAO90JZIQfPxbz
         5Vzg==
X-Forwarded-Encrypted: i=1; AHgh+RrpHw7xuGiyStNXdvm+7RjKNAoFbDdbRc712Q239w8Ah3xL4b0YDLZ1PyUtUOdWHCJeccVcoTNxNQ==@kvack.org
X-Gm-Message-State: AOJu0YwjVDSAtrY0dTM5FM00hkRz+7Ws6YkHG86tb9bGLcAXBzEcIB1n
	dy0I+7ECJbq3S863wrAz3g5wjKsZBJWVa29CmuCco296EjjJ0bPWuxcq
X-Gm-Gg: AfdE7ckpUeBpRxDpJ5MnGab+aKVVquv2lz+CZLJvuiSum2gY5loDezRJbNpbMlBwUeZ
	cmhxoBSI+hTBcVH5HQMfXIrTqETO9q9RtU9tHSX4jb+Z8CsaowvbfLvKL7/w8/UDMdTslbnvkl0
	4KcvYUNCv5Vmqt1PVGArdB/k0ZB/CiIgO1t5GZZvDUCleLcYwH4C8YrLwyg7LYUyluai7pJcMRa
	FjUxZeFXXuadAnCOTvuwJP6g6K1UT2fXpNxoVavU4PCb8zy1eT+qRV2Sfp1jEw+duJwyXmmSqqJ
	GG4GAauuPyVXCedl2E7nJffPaK96rjtzcJ2VWyEouiM8aoU3kueSbrAuXn2XI6fpUG4CapANEkA
	WU7dOg5S+pnSE0HKy/Hk8wwMMjNUDDVmkZMMApFpwQJ72AIkH/lA44rWLwOxL4PhM/GeeQftu8a
	N4qzMf295r9d1pPWjR
X-Received: by 2002:a17:90b:258c:b0:380:105f:8ffd with SMTP id 98e67ed59e1d1-38e29fe2241mr708416a91.16.1784075337235;
        Tue, 14 Jul 2026 17:28:57 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm86075098eec.18.2026.07.14.17.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 17:28:56 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 5/9] bpf: allow fs kfuncs for binfmt_misc_ops
 programs
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260714-work-bpf-binfmt_misc-v2-5-57b7529c002c@kernel.org>
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
 <20260714-work-bpf-binfmt_misc-v2-5-57b7529c002c@kernel.org>
Date: Tue, 14 Jul 2026 17:28:38 -0700
Message-Id: <178407531871.2243172.8952621667118278231.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 5CA5740007
X-Stat-Signature: cd9gybg7sptirufm9t46h87n84iyc1sn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784075338-579173
X-HE-Meta: U2FsdGVkX1+FvykbMcSVDq2gROey9IbeBnuQxlD5ZNKP4B6cSpAhBZQhWdOD6kf6wq/syoV/0bPAsemYYwTCOTXULDuZEUlUvvS6DwGa+KkTHZeY0ySI71Gh6HpRfenBtE+72h3eUCVxZqp7lg7Ae+BaiJPTW4KHfl/0MqivkT/sbp2U801TBzK2cxudJUCn8GdUyoBZ4WV/xzsuaVMvj7LWT90dEZqke3u3VsHPovavfB/Wecfzwna6ppHQx9fRvFqZLGdfmKePkc/MkIR6HK/6Hd8pYgvcla7iYsYaVlicenetmOSuVAQmUrqao4F999mNxcI/v4u5TgPTQ4dBKP5lVZta8Chxc4VBP5zVBnWnWh3k0nP7qBrun67QbzHRz2cR0p31vuW/CaKaidc05hxMMcYXdkxjf7rZdGTOG5tH3hMqFzeLDTS0L7BmSCJI77i3Rf8Yo8buza/gQUDv9bzVYBF37ES/uM47OJVcNYoq+ev/WpNlVwoG/VzTVHfa1b542cSr6iMeksy61Wgn+XkKDcERNepi3tuIVtD23MKh4WW/v0kVd/7CAaak7CrZ+ZC6xsuGBhbXExb+7GTjUHqgGB9SEVWwgMUzRsd5l6FMSjea99P6IltMW3CGYNJApvcTVEI+noP/M0GvKWOo47c+Jc79Nbew39Lp+XEBLZqJemXhXbeIrw/vTAyTLTzDO6hhMaiFfLYVyzCPH5mmIZvwY2J0gvXnWJc9vpv9V08PWZZDHLrsDtkkbvJztHskQDulBwEEza8lAEH8z+f5RunAb/fgG/vJ+S7dj860QlUuB9HaWp5dZbG+uedSZ0cYtiCpCuyoygHClWX+/lE7r1gMzRWmPpJCbBCodVgatrsUIQcOaWXdKFCd/yRRQjFr6u/Dju+xZ335rBzs1wGm7GjvvuWn7pGGCkbH2x3qYt/XvMFnG/0qzUxlTjqhJ3udtBm3LxAZZNqN9XdayUu
 YtXuG9wx
 33V5HYgWmPQXCXhdMrDsoZwvIzdGX+l/6u94uNl4u1WJ0yFlbAaKaPp6TvHwtL/EYaCRqYOo4Rh572gT00bcI9p7ohHR7aWKzWr3T0xHu3BQS3lb2BPhI6ZHNM8t/a5mKMdD8I/E0adlbeRGqe7gsHNvujO2zRiF7YpZeNSef5o26n18lXQ7ZNYw33Tdxfeh6MZvhl5F0zLOUHLF/1DnQY1/jjNufbAln9ULoPearPX3tjNf7fJXUOb5ORJQak8odxBuHO5KdATmySZ6yrAHJ6jHxb/5dfv5AUsD2PKxGok/R+iFLzObjpMiCDX8meLoj7tRAR2k8RwNzaXIozNtX3B2Avi+gVBYzOhV3k3+NSxOECs65Yu7vJGuCrueXN4SbE7wneS+nRYd8e7llT5vLw4K9r4gENKHxAZmdkxV2XTapzjPwVPdqH0QtIDgCZRbeCPNNZYsyTPJJBFvzAmJVIjgus9SfVUGpmDpPfU4hEIiCaGMFL23sR+ULBjWLeUyRoOFoUZzAahOphzHNAQKyeiV62pf3TF9r9PfUF89yMWHVBzep7ekPcKkTBC7DmMw3k5pX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 21:58:10 +0200, Christian Brauner <brauner@kernel.org> wrote:
> The fs kfuncs are currently exclusive to LSM programs. A binfmt_misc
> handler needs a subset of them to do anything interesting: computing an
> interpreter relative to the binary's location wants bpf_path_d_path()
> on bprm->file->f_path from the load program, and matching on per-binary
> metadata wants bpf_get_file_xattr() and friends right from the match
> program.
> 
> [...]

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>


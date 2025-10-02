Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34265CAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 02:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9518E0003; Wed,  1 Oct 2025 22:50:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A8E8E0002; Wed,  1 Oct 2025 22:50:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6D68E0003; Wed,  1 Oct 2025 22:50:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2AEB18E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 22:50:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D18611166F3
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 02:50:06 +0000 (UTC)
X-FDA: 83951644812.27.F349982
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by imf06.hostedemail.com (Postfix) with ESMTP id 226FA180006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 02:50:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 3XOjdaAkbAPElrsdTeeXkTiibW.ZhhZeXnlXkVhgmXgm.Vhf@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.71 as permitted sender) smtp.mailfrom=3XOjdaAkbAPElrsdTeeXkTiibW.ZhhZeXnlXkVhgmXgm.Vhf@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759373405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=IXkCYyVq+Ok8Rfz7LkQRm5taj3jhnYdzLypCVreUpOQ=;
	b=XwC47I/o/SDVHqf/l+LpGv4RhtPukYxprq/mtm4AHmlJK2o9UaQNmd49O3dwt1pNUqtAT3
	g22EN4yd4RkFCy/JQ3hkqHlbjk3ovdRMcvcymKkUPfJfSacBGIWl3o0RolzDVEv32m25LU
	s8/DSZ3jksmabrImIUgA9faZzZHb97w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 3XOjdaAkbAPElrsdTeeXkTiibW.ZhhZeXnlXkVhgmXgm.Vhf@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.71 as permitted sender) smtp.mailfrom=3XOjdaAkbAPElrsdTeeXkTiibW.ZhhZeXnlXkVhgmXgm.Vhf@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759373405; a=rsa-sha256;
	cv=none;
	b=CV9LWzCZMuDgXQJPZebep+KAXAyWgdDP0cjSEAgd+mHJ+F3sGpCo5P8xtGuQXW8XrCu+P/
	k/5Y3G5EKckPkvFVySYUj9Ap9zjBZxKczXelEHv6Z9OowuXCa+hRWtCdt+R2oabiA3QevD
	jyLFsIRGS7kLX2aAmWGnVFG/saGXrMc=
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-886e347d2afso65429639f.3
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 19:50:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759373404; x=1759978204;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IXkCYyVq+Ok8Rfz7LkQRm5taj3jhnYdzLypCVreUpOQ=;
        b=MjlLoYGfG/nMZ0FN1q4X7R4IGtTUCk1TMeKX4R6rR6uJ6xV01vbWXzIj3n7/K2PGxc
         ZMP7bCLQn+T/sWPfdrPIDvBJ2PXTv511ZGhnLC16eS+qlRjjZRfY1+wQijOLLc/lb8OX
         Jt7dGFRMcGVNV/jf/q+dSm7tN39tqDzGrqKmLgO9t+/N71IYqffyU3bJ9yHrioe6RR9M
         Yd8cedcuvFUmRt60dWAX8H7hnQXXsHdcdMN/I0Ph3oQlis9kRxXaUC34EKX28SMELHuW
         2OWR7te9fh5Z1H/iVlUFAyE2ZBrxUgBNXs6PpH1knQ4q+KZjoArBhUH8n8/egdymO6Q+
         8fJA==
X-Forwarded-Encrypted: i=1; AJvYcCVygp7HZJRf2IIM8mDrPlyQ0k0TlFNUY+Vf+6LDcH+RdRaBUoQsQ2m4v4ygldhtU1xIdGHNc28t3g==@kvack.org
X-Gm-Message-State: AOJu0Yw8FWYm7wsHLPqB3pNFHxaVjS3+Gavrp7vHm4fePvTK9ttaTfYa
	rhDsDeDVAFYGrEcxWjXIpzgUJdZBdeP6m4qzWmDqkpSWyCJRzdM0eQxXvgf4G1axpxTLcpF801p
	f3E+UxQ2iHxreGsNsSeEzcEIwoI6C2fYI9E0KrJ0qLNuuNkAro1bZ86Ulq7k=
X-Google-Smtp-Source: AGHT+IGr+AJiP1ZEZ27TFDXMlUXIf41qC4roBHiJek7Cv7nZRHTTs9a8+sccW0Tp7nADTyHqjW7I5EQfOoNN575UDOJAH5EEpW6x
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c82:b0:938:9f22:ed34 with SMTP id
 ca18e2360f4ac-9389f22f4c9mr566606539f.16.1759373404188; Wed, 01 Oct 2025
 19:50:04 -0700 (PDT)
Date: Wed, 01 Oct 2025 19:50:04 -0700
In-Reply-To: <A4321695-9F12-4C7C-ACC9-72FD84B6DB2C@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68dde85c.a00a0220.102ee.0073.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
From: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, jane.chu@oracle.com, 
	kernel@pankajraghav.com, linmiaohe@huawei.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mcgrof@kernel.org, nao.horiguchi@gmail.com, 
	syzkaller-bugs@googlegroups.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 226FA180006
X-Rspamd-Server: rspam05
X-Stat-Signature: yokpfagj4auukiy5q6rds4wh7t466nhe
X-Rspam-User: 
X-HE-Tag: 1759373404-19087
X-HE-Meta: U2FsdGVkX19GpE8+tnMYabKKTgG7T/Feyc/Itcv1xohHl9MaPqDea6L9EumDOgMoFWNZ+jBC1HYRoN4CqyTQzGUHja6uVx4Cwm/ZwRKl75/tvGS5S0G4OSfZ4yypyWjZLN+V9oM68C47X2508O2PVEWrX9JD/UFUnMvfVTofAd7ApJl+bhYi/4RGrOXVtX5D10YEgImvOptVd5CP4Yw2El5QPi+BXK/WGWxSaMj7woy61rAPC9kvEDI+jFiWuqdZRGkUcdAM6lY+49HnQQQeHUQ1V5qAJwG3EJyRJGQoOZ5IqxeLcxRn7bmKEq30n2xByRLJy2fnfNBO1/HtTcnIfFiRr58/dLJ62NKmdgBI4FLUOFJsvNphBB9sxZQyJJKP9REIQYLI8D6L5SsryPYXKWXEifC36eS3SxTn2T5mpmflccgeeuDU5z6FqznP24JyAjLsLJrfODDw4iAiZTQJQepME9MPsfBID5z3E/4uyswaXS6z8CT2tR1DgyhcUaeVg1PERp8QFCtGtlb2aGYY4AuTU962jf05yslXFC5AUtON7AjARj0l8g3t6A07fGw0bFY4ZFqCphqCEZ7kiCle66dVeSQnI2xluTgXCtOV+qgq+m2SC7OLXNRX4Zc+1sC3tvtoz/OPuyT4IO3JAWPcnDuGcDWVyfIKOv9RwN+V/ZI3aqyZXeNH/8JY4au51UgObWBrXlx+/QjSF9lfwxaxbjztSOmt3XnHVQMt/Fc9SNoVSrpT6n9w/F+mXTUQe5Kam6v2woVYKhVsHnK4MJnUqsUZHgriLlHtWypWgxh+fCcRv17JkV7N0sTVhHKljbalbgDMs7kneNTcBm9XT26wiS0WgVDIzDAVmMvA4mJvcUJ0nGsFbZpxusZzg3uC5FOjy1sfjM4WExmdwMKjynKlyT55B3rl59E9y8qdthocFywEnVji4zSb/R0Fede0ymGyGvM7DVFwmH9Bkfb/9Cc
 j4dJCnd4
 1LoimRyfJK9iICrDREAQR5Z57nvQgEmYEUI38jc8NkaA7bvkMUS6jC2+Hl1x+6Wv6/TL91n40eMiGlacBhH/NgoGo1T9ELeMJP+BZlMnQy4GqtsLVv/fbmSqgxiFIcCwNjIDOlbhaJut0sxVLLMWar6TbvXls5dxNmn2gWFUK4FEIb4WVKI7YLS5Y+TDt1nLk6IQfO4xPl4e3DhqKBgY7wstmbjkGw2+sLBN0CfxBDUu+pmHA8xgS6WHqzaWjAJg8LTO5HKa5l8Hsuq47N3VO7gLDAiux1banGdFmsV4gZBZxSSsORpVKqbsibGv3zNVU0GT5Ud1SS9lywtlNbec/D3ES3IA5qI0DzXqGTyl0nu1Ow4xPacI3sHEiGO5fReSca/DFgW5i0LVfUv3J6zwPntyfKtEkMm73D+FPsnPUfi4+cvy17tVNQp29D0eIwd4pP5svnGbsJpQ6mVNiNNOon2HY9VzOdzJ1dBbiAGw9JWG75CMcEVhn7x14sTdAoSNMiev5Z31f429/1elYwLft+9c243fN2u2lEqcwp9d7ig7MzbEvUZeev4MYLemD5bmeIPEm7sVB9wfTOfXUtF8Hv/mpk7cZWaLKvUTrxfRMj7wUZ5t2Tyo1b5t4DNeNRR9vOvj7zYU8DqfzlzbB8FpoRFPx3MYYnzbVhxl/P9dAvbj9xmBm/9ZE4/C4O73yI3YDDTD8ql1aimmSopRnqX5fKctzTW9ijO6V58/QxPwzMg++EKryo081Krl4kBo0gA/tsp8XulU2O7WOPdoiNHghcUmOjpcVi0VYMm6rG2Ts2MX8nXeYABQqb8MzvoNbkLxJAiUy/6dVXZ0kFfKxL3UrovB8kr0Jqz41fxK84x97uKzyfOncgXwJy0bBZbPhPnE4W8cRnXQqSycTEIy0VbdnWCTjb7s/ZWd8wCvlYXIaIM2AEafN+YOzv5IDGuTO2N0ak8LMGDCUUNgHOXLPqDlWmPuocJSe
 ELOkX/Sk
 8lWmomwtR9p5syUnvcIzQ4XeBdR7kKVIUo960mi4V7ww1eb5v756ugjktGJCtBdYMOJnl8CiDk35ltnMaCH5HrGwOrjrNoQGMOT+AYs5fS0Fewl69TUuqu01GEPMV5TQ1c5Ymn+gtwzggmEPoaR3195RpW6Wz13EmvptN6L0cP4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
lost connection to test machine



Tested on:

commit:         9cfbc23b mm/memory-failure: improve large block size f..
git tree:       https://github.com/x-y-z/linux-dev.git fix_split_page_min_order_and_opt_memory_failure-for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=118ae05b980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=714d45b6135c308e
dashboard link: https://syzkaller.appspot.com/bug?extid=e6367ea2fdab6ed46056
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Note: no patches were applied.


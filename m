Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8591310F3DC9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 02:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3136B008C; Fri, 27 Mar 2026 22:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 774126B0095; Fri, 27 Mar 2026 22:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662A36B0096; Fri, 27 Mar 2026 22:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 539506B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 22:26:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBE708F5FF
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:26:56 +0000 (UTC)
X-FDA: 84593884032.20.C48311B
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2A0E240005
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:26:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FfH+pHxA;
	spf=pass (imf04.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774664815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kb6J4It46FKMZR7TYBK4AeUBRTxKgKLr3E2XeVlLk80=;
	b=KpBtletEQVew4EfQFHIfbbh3jbGnOchFX7VSI8WZJfMXcYuWusMEmWKVrhSqvXQC0HepVB
	nmAPnuCMHZ/1Q9qBtHIJGMha2RWSti3U767Sohls2QzzemZWSesiyP2Tpi9Zz5b6Nf8Ol/
	LJXD8ISRtzn2bxKhO6ONGXGZ78PSawg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774664815; a=rsa-sha256;
	cv=none;
	b=QhYQmsp8cRPWzXOwVeyqj99qwAwBdGME5Xhb951HfR1TvQboGrB8SgvPrD7XExOgSjFwbp
	3yS7vOwGmdHwsAA/Bkq6QHmUZPRL+y7TKaWt6TomN6kSFTY3Y+K+UXGfbJQdhCzHIOUK6c
	iFmJQ9KAW/cpOzuUJQFAHVaQ+NbXvD4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FfH+pHxA;
	spf=pass (imf04.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so1733064a91.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774664814; x=1775269614; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kb6J4It46FKMZR7TYBK4AeUBRTxKgKLr3E2XeVlLk80=;
        b=FfH+pHxAo9aapWnvu/1CcnWIDXiHX6cqaASQVDai5tYt804tX6wFAOMOrfZuq0ShiJ
         o3/RuBHh8guqRd4KGL5JadLmIpfiobOUlzxyUp6TvWAUVCM+O2GWULUOA9UocvPhWPA1
         2ZOGruRny6WdRt95rbkyJ26ph1r88k2MfggfESFWZompEShboodT0OfNp6Rp00989kl2
         W+/FTQN7I2ZfHofXMoavw3eRJ2TfsNNovolW82w+pf9S8c/2qc37dKv18XT5MMVdQRW7
         wwWgzmxigkSNWdJmDVMrs24n+NibodsRtcOY9Ce5shT8p93PzzesM/bH6jthzkH85S4w
         5RIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774664814; x=1775269614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kb6J4It46FKMZR7TYBK4AeUBRTxKgKLr3E2XeVlLk80=;
        b=K5xbphlci4bWPefvj/1jm5QOGdJmVr//90sId++9dAun3wYc54Xw4ODOT7oh7MP7l7
         ALqSoFqA1xyDw8tKeL1x5m+1c0lZXcpmThvDlCNLkDT8He9aWsNKweg++mR5R6sktTUa
         pAuFkud5t2trZtvuRS89NizoXER7q4FaMbSVFtiaJNaxAcmMTOpxSSRdxYyxoajKvrqm
         QdDd9lypCaJzdKJALKKt9Vv4S1UxYyLJGjvyUHDYOaLOhhHXB5RY7AGmYfat3Ioj7uMd
         Qm5j9wyrXUuk0ICEz7CYiW9zXrfPsgYQDpxV/yHuH442v92lT4s7l+XAgW1SvbLkmfPX
         qvlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLeLxLiWn3DDujN0m5tIF/yCjNXknAoGOa0Zu2uH7y4K//CZs+UuaBscCF+0xL6C93OsFeqBX+KQ==@kvack.org
X-Gm-Message-State: AOJu0YxlfPDYSWT5eNVooBCWyrHKKSEUmRGN1QONM/qMUP3DlJQJ8EmX
	nZW11NS7v5RIftai5g4uzGbWvOwzhoJFux6MDiO5zj55JOZIdPD7ull4
X-Gm-Gg: ATEYQzxvEmgLCDBLttTR/ioEeA7esZKqI8F0QRy267MvtkiDopHiJeKhHdmbCmrgf8V
	Nq0OHCfhw23rCnB2l3m98EiFrxhU/6whVMssaBl0HdjbBxqrFJJAKx1sjE/vXWN29OCujrTMZ++
	E3lOdeiJBWpAymYZwOCJYUJW32/zFwT0fyEhqYirDbzyAqjkVaPgNrTq4MNogQDRo4Ot/SBlHXo
	x0rgh58Uj4p1nO59RTgWZjHe8epMTenoqKeHvmyTIBOWB8kiYqpXE3tW0T1fE1mcUMlQU8tKVSt
	PP/oOYvdt5a7Sqfi4mV/Xv7LAsqsba0Wz/v49iy6yXcKCF02CN9sVZ/KQC8eDxEQPwa+hRt6nyy
	cup3LLrimotDTi+UsEaantVqgvOgGhaN5+PGwiPfZpAgbZswIkfxGOB72RYuWGGi2RtorwdgoAW
	M++6tNzq7/mz6I5gfaSxOius3aoFx/YfwXj7aU8AeNLQcmLdZzb8ctfL3VaUc7gw==
X-Received: by 2002:a05:6a20:7fa2:b0:398:abe1:ea8f with SMTP id adf61e73a8af0-39c87af31c4mr5044717637.44.1774664813633;
        Fri, 27 Mar 2026 19:26:53 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c769179e31asm412710a12.17.2026.03.27.19.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 19:26:53 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Sat, 28 Mar 2026 10:26:51 +0800
Message-ID: <20260328022651.41744-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260328001405.4253-1-sj@kernel.org>
References: <20260328001405.4253-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 4zaazpqzk3q3sf7zi3jcwdb8d3bx7imo
X-Rspamd-Queue-Id: 2A0E240005
X-Rspam-User: 
X-HE-Tag: 1774664814-175872
X-HE-Meta: U2FsdGVkX1+0cBfHA56adsanR+3H2vCiRZBLQf/G2hxZjrq4VXl49pJ84SgBR07SDC16Tm8WQTmn2LkYX7pmdK9r3DSNDQPyXCyGJWqqd/iTfOy8POicQn9f/b844CEUnUTK9i1EfRfT3pl5etkJaIwYGJ2ZxEE+ho3k0TqWq8pJxlN1em2c1yZ1ZXMK0MZ1PWDQJiYiu8zrMdZdRmNg7jJatocb4EpInBBUgRWyTjv3FJ6Mzpd0oSpR1l3ysB/5L1VRQfFTK7mD5ukwBvcdjuKv9ZkgAJJs2rS11b99B+6Iv2W/Cjk3Di01Sbu5qnsqflknOtx/QyiDJWrUWgjt24F80ztTBNtGsArcmAVB/LdHeRyxa7P2AoHi/tR5gndBq+ONItbBcfZoE+O3usWHCysojQNtPTfXyGlqeFcUc9CIQTbt+22ai6QwPsjPy90+aQrK+szlj470yRfLN6c/qoq89TB837cMzrk19Q4q/j/C5S2/x5+lzTysWd232E+eSHEmq38ZAdfn73qNwN/813IoQvgI0hkn4HiQV/z6St/nFB77eu626vMCBYnnVRTvL8v4NJVcSixf81c8ySY8GpFRu3vSRGNvd2hJlMRPR3FEMxmqj20QSp0KU9qP8YyGvbb3RAPvxUITCoy1ytfiUrGPvWMgHIp79utoIFLLc3qEbX5dhGXKu76wy+qOsHAAztZEsLOGb0Rx7/TBYNKxPMEPyGQqqytjMlNJJLIjpfiBr/bcDwn2v8cBZlvl3sb/C2P01X5gdgudRezxv64YKuwPDRVfWZQaJXX1DBqh554ebuXly9F4Irb1TEL96+Yze0q2eQ+a3UEhX3PEZnDMKPRr2Vf6yb+hde0flwwdG4tMFCEAKSW5pITOeCPY04bE+0IOSeqyRNEJ9/Y4DfI7GpmPHvVDzJ1ev6ibfviCdb6KbX8GOxMYtDK1uXYRqhPT1niXKi0opM1Mv+mnWEG
 r9xQEUuh
 IQdeHZwVzbl564g9+4X9usohJjTaq5nYxLz+zo8vjX1mYwRxg2BBjHi4DdEjA3OA6culW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

> It would be better to not terminate.  But not a big deal.  Users could be wary
> of the consequence, as long as it is well documented.
> 
> From my perspective, therefore, code maintenance is more important.  If we can
> make DAMON not terminated by invalid user inputs caused damon_commit_ctx() but
> it introduces a significant amount of code complexity, I don't think that's a
> good deal.

Thank you so much for the thoughtful response! I completely agree that
code maintainability should be the priority and we should avoid
unnecessary complexity.

Just to make sure I captured the full context, in my earlier follow-ups
[1][2] (in case they got folded in your email client):

- Does the current kdamond termination on invalid user input align with
  your design goal mentioned in [3] (stopping only for "internal
  errors")?

- Would a lightweight fix be acceptable? For example, performing
  validation at the very beginning of damon_commit_ctx(), and returning
  -EINVAL before setting 'maybe_corrupted' to true. Since no
  modifications to 'dst' would have occurred, kdamond could safely
  continue with its old configuration.

Thank you again for your time, and guidance. :>

[1] https://lore.kernel.org/20260327064517.68131-1-aethernet65535@gmail.com
[2] https://lore.kernel.org/20260327121009.38374-1-aethernet65535@gmail.com
[3] https://lore.kernel.org/20260319151528.86490-1-sj@kernel.org

Best regards,
Rui Yan


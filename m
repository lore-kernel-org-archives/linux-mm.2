Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72301C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7052D6B00A7; Thu,  9 Jul 2026 10:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DD206B00AB; Thu,  9 Jul 2026 10:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE726B00AC; Thu,  9 Jul 2026 10:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E9576B00A7
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:30:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D09F31C7E43
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:30:58 +0000 (UTC)
X-FDA: 84969474996.28.586F36D
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id DDC5040015
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:30:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EEWMmP73;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783607457;
	b=Ffv+zyQcYCZHBbUq1VuTRgd8wf1F6AVCA/I5jHHa+0BKFVHSzRhyw0LvQ+3k0VoNssBfPI
	yR3QTKo/+QmknMXnG1y8IixNaUgcuIVaPYNDEtEZ7zYWEDhwB+ZFfh26fU/o6x68bJp7sC
	wM1+UH0kSw0qSRdj06ofcc2uQBNPkAM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EEWMmP73;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783607457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Mnu8ylsDHpO+mw+tq1vQqx2VIcm18P4eTlOKV9syFk=;
	b=WMKb95iT9kAbz1UaenPJkbseEvJN0/+PvgAmqByhoqpmYDE7rzADrWhfJchaGRWPmr6NjS
	B4Ng6UdkuD3bHn1rAITBe2Zuy7HEIqDzBFh1s1P/y7FmioxKJI9w3YTwb68OQH03Ngrnol
	VOArzLad8gZS0ApoznqIi9xyaFaT6Hk=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7ea9c6ea7deso1172152a34.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 07:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783607456; x=1784212256; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2Mnu8ylsDHpO+mw+tq1vQqx2VIcm18P4eTlOKV9syFk=;
        b=EEWMmP73w7uwaDZtPkTz2YVdSNLJb3cpYFdqIS+r8ZbxO3qJ4k486GBTg+ROKwjHC6
         cx9giEKcxtVBsTcgwWkjP2jkElQb6lmonVOQtAnjuQyN/P1J5yTITKwZ3XCQo9CILNIT
         ViGdSAIS22gdh8nDGXeY6STsEe4BvftC0D6KGfD0Xplb3mOsNbiC7FF7SI8ntopASYZw
         6EzPjI1hJ0KTrXnpSb7d8oVkxmgmbSs29lh11pQZWjj3WoPtqwxTAyF3Ch5aBRaaRl8o
         XLFdzLrYztVqnToP5EKbX77UsiO+1k1IZE2wpdLP4W7iCeuZ3T3caBE60yNM/2sJm8cH
         9ICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783607456; x=1784212256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2Mnu8ylsDHpO+mw+tq1vQqx2VIcm18P4eTlOKV9syFk=;
        b=ETGOhjgN4r+3WM1xQYGzIgajLSFSkvEbGNVeC0Hd8jU53FFC6sSHfEBu/Y1ZuR/ikX
         zKj9CqjppW9hJgEs09W+RUaq4bp07350Cy/aNOO8JSobl3L6C/Kom5BgXufLqgqPpvzn
         Y4zJE0jBz7C7PgY653G9DU8m4cvcqhCAT7z3lzRNHh/rYBT7Tvrl1XS4YnFym1bX8/LF
         +F0F9RnqocJFzT5eqs2SsyvxDzbLicCD81erJDTeTIFfQ3hnBmPhRC2pQAFVfGHtnEON
         pVWMIdsHnVD0gjip7fcw8pJ4vS9OBt4w/mYO3QFk0iasqryFGl6/zVytj8J0ljfPMcTT
         pEzw==
X-Forwarded-Encrypted: i=1; AFNElJ/Elzzk7tzg4iWkPZx8jgJZ8tS8eFoEfk7v4PVkO/NDtqXc+ZIVsplDx3Rxo5mRtS4h9Ta3n26OBg==@kvack.org
X-Gm-Message-State: AOJu0YzK8O1Gmn83hzB5MD4oVhWRT9dzUgZoyrxScHvuMZ/Bq6RL52M8
	BNvCpzZPchTR0VxlBz2HUTqOuZO+piMZKGFVZbACQXN98Y3e5jRNxVHgpX6gMA==
X-Gm-Gg: AfdE7ck5fq1njvC1FhTKMBu3PSTje3hdKRsb9ZxuOPgZNDw9D/tNNtU8S5RdZhOSXUY
	IxriXKZJ1Em8ntV9ONDsV6NIQPRhvE6rt5q+nBDBhw4tqQlOx98EOsqG+n/ifDvQ2v2vuFp7+rL
	mrvaGAoGkCr1TngZ3n01t+h9KS7mp/ddiqNBCz93ebAMoqYPnuV4DG8G+/ZYA2ApZg+4HMRXQgA
	4KWiL5sTStL+z7/ilb/06nVTvVZwVXxFRtpWlMRvRQA7iNuQxcCHQ2V0XHXeRGzlZMCMWzVb213
	mbkHUafcAQOyQDbiIz6igqfwR5ZiOj6yBI/t3cGIYN8P79G87a+jE++2AM7CdPLyfWxRODYtLdJ
	xMSCVgMJklu3ho3YP9fyTk0K5sra1QUvaRaaGozU0/JwbZt3x9sh1O6lJTbzeN8gfQxLGWmGkTk
	xVldG0MSYajn+BOITYGtKN5p2dKDUjNdBjwuO0PwZo2qQ=
X-Received: by 2002:a05:6830:6112:b0:7e9:e3cb:29aa with SMTP id 46e09a7af769-7ebcffcef05mr5983352a34.29.1783607455876;
        Thu, 09 Jul 2026 07:30:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:18::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ebcab8efc3sm4168157a34.0.2026.07.09.07.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 07:30:55 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: chaithco@redhat.com
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	arozansk@redhat.com
Subject: Re: [PATCH 1/2] mm/hugetlb: Prefer mempolicy nodes for calcuating surplus hugepage reservation
Date: Thu,  9 Jul 2026 07:30:52 -0700
Message-ID: <20260709143053.1188272-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <BT4VHT.DYI921C1JF9G@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DDC5040015
X-Rspam-User: 
X-Stat-Signature: ea9e3eu43xa3yetu4gkootm9mcax73do
X-Rspamd-Server: rspam03
X-HE-Tag: 1783607456-544368
X-HE-Meta: U2FsdGVkX1+Oi6d1XE3lWodcphaZccYxGRkikrUi6HGbK5vwtz+Bns9fkGJV34KFCWbIk+aphtbxau9ptYAQQVYA9p25PC00CLW+5003Z5VIOw3RPV7uqdeRO1DTwJt013K1yNDZZq2XvCxIMhhP6a1PHmV2Pf71IN6zFLAAVe0yBIb4FEDWLQDmWB0asKKCimtOTka614wqr2ZZBDUXrEYaGv9IDxbBgT/lAM/rhzX6hxUF9ZldOFUtFiWQ93kmQWYZuip6MgLsb8TXaLDvWZ7XQqZJhmPr1UjzkaYYbZOCntLSXXvK0ncTAvAafe4pSDcfp4xe7c+1de8xSBzg4DFsqrb+uqr/9qCXssTMcfgrlgYV5CE/rLIfurlXX7xzTMPj7umDv7HdlJ3SDfhjnwEucMTf6zseAf8+gulFpKSuF0iY2Rb0WeiRpobsH6j2yaFQi3tATgtN/zqK5eXKRf4tfSuowNKiPkscmWJL+R8uz/D9QfKQqWc7arpSPPjPhsuYRD7yYdKgZx9xRUbYoJwQv0+XtoRpf/X/ApuslF/phgio6OP8Eq0upB+7N3SI4EDeCyiMwm5v4mtmjuHksfLq71Wyv0kZnaXxp9+8vPVGnobA1Nojy1P6xGYPxx6c31bTrqbmV+zAuOrhRjhtTBlZLd0UXASDp97ynX+OOJ02tgTR0w7gaafoxcpnVTovcSOfuNQnQl3O1D9k2ki29LvhpFxcEqk8mxw998qm+shJwgeonBqsLo8Ydeq40UTR3U46TAbsPQhiZxSln9n9Tlc5Of8YQCOjXu3A2i9D2lUhX3r6p4Rj5qihnqZKx8RH4LBTedMz5lt/h4KI/Sz5t3IVI4kDqSs/7fPb3cl4DXHmKRdnfpqxgxef9ucHCl/MfloESKNrbNRJmIbetGZMjw5e5PfgJN2//VUIDI59j9DYOUwotiEBg1cRcl5kbs7xvhqw9jVR7gcgcOV7DA1
 dgG0P9UV
 Tv9ZWUb40VTBBQDetzm+YII8L0xW/9zFgQvwSWq3gAh2ZjmVRnL9OGbip+xTE1DiTpCWZWf11g00uaC/2MTrLEFy4DHpFkIFG6qq8+0F/vhdxganBDN0HettuiJAk5keKwZtURItvRhVDmUf4nT9Gj4+mdQXmeAnclrGVVKy41DSHVk6RCVIme7jdLTjz8W8Ml+qD6bP1bXEidCplZRZGwmJzRQpsQvYnfudsrFc9cNjFrR+m2QlJbtuNehURfxix8AOHr3xJRvp/yy/FluXJBifXiZp0rPeiXN5SkjPmGJgRejBc5WtK5xHgFRzPzlm3FfUiz512rJjUNhPyN42Xrh5R3WP7e8dM+JrWwzNK82/ZhVj0gJ6ku3j+7k+tpcLfy8qWcjmeoxjVnQjOo+OpYwkwZdJx62VA4y9vhjASWxm3uOMtZ91EuP3iMmfFRZkYiyKn+Cbz2MiP9wPhbzM0gOdw/PQGOvEtoeF2PUYZ3YBDCfuez7f0R1vqvUp3VYBtobwzVpNU8KtXM2t1SAJHSKMNqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> 
> On Tue, Jul 7 2026 at 12:33:57 PM -07:00:00, Joshua Hahn 
> <joshua.hahnjy@gmail.com> wrote:
>  > On Tue,  7 Jul 2026 12:28:55 -0600 Charles Haithcock 
> <chaithco@redhat.com> wrote:
>  >
>  > Hi Charles, thank you for the patch, this looks good to me!
>  >
>  > Personally I like the description of the commit in the cover letter
>  > because it provides a bit more context. Do other reviewers have
>  > thoughts on this? In any case, the code LGTM : -)
> 
> Thank you! If people prefer, I can copy the cover letter contents to 
> the main
> patch notes. Just let me know!
> 
>  > BTW this is a little strange but Sashiko seems to have failed to 
> apply
>  > this patch [1] which is strange because when applying on the exact
>  > same commit db6ed2a3d3106 "mm/swap, PM: hibernate: atomically 
> replace hibernation pin"
>  > as Sashiko tried, it worked & compiled for me with no errors at 
> all...
> 
> Interesting; is this something I need to act on in any way?

No not at all, I just thought it was worth pointing out since I had
never seen before. Thanks again for the patch!

Joshua


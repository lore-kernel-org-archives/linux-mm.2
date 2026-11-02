Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9018606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vQc0W/+D
Received: by kanga.kvack.org (Postfix)
	id CE6266B05B2; Mon,  2 Nov 2026 13:16:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98FD6B05B3; Mon,  2 Nov 2026 13:16:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85F06B05B4; Mon,  2 Nov 2026 13:16:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87F856B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:16:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8401CA72DB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:16:32 +0000 (UTC)
X-FDA: 85390984224.29.6ACC9A9
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1B6EE40016
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:16:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="vQc0W/+D";
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.217.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793643390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9ICWzy7eh1ZDcwlW7hKp1lrYbcuv/hAuIABl4o9hxM=;
	b=ZRIZUS9TOBP6+SBxkMx/k+uMT+esC4Gbvz5VgVGBD/nwgU3bMSBIJ3Dj6Rm9KdhpQ+4PR7
	lmUgZcEsXRa9lwLA517zxWBPWLFKvhsdjRfyDE3hMCUAhoVGott/gmPr48DR0SCI/eav0M
	8GiY/ci507CZfhmqpk6/h6JcjuplgNM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="vQc0W/+D";
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.217.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793643390;
	b=QSVseDfNRZkylXWRmIIyTxrQnziG8mawiUdS+38Lq0OC6KbfD8Ch8e7LQdDgwy5iYBsFWh
	XDWVGdH6pNxA4yOQJXdSB1zNFgUzOjxRVEeaHmrL8PPSZFUGJHTPkHEZwxkrgqDvzKlCUf
	tSqae9CcmslkvEUehen/aRVTTo4a5NM=
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-7c3b6e8225dso2305965137.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 10:16:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793643389; cv=none;
        d=google.com; s=arc-20260327;
        b=GWz0q/jdYzKZKb1Qfv9yMJh7eEADWodwVsq+0kELNB28hC41f5s4Q2nUHs1H++J2H+
         ObNbCZHdG/EwRX2KLqAmoqoXB3uXlaqBS76j9YRNik+t7BJ3p5E+PthLY7IWWUmT+ttA
         97yiKCCwjmbFVSB3RQv8Eu3140BT/5DW1ntSJvXIeryoodS82x9+SiexilPvk2sZQ3R5
         hXQ76K8wYu5Zi5lpquIqEiPZXIgWtlufCfoyatiRavrOVgSIvjADA486Ypd1IJXbiLaG
         nnyfaIZiZFw7sBs711aFuKs4juc3RlIS8E0UVmBFUnPaYzYgIQON007hq9m5P+kN12jB
         9BsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T9ICWzy7eh1ZDcwlW7hKp1lrYbcuv/hAuIABl4o9hxM=;
        fh=xx6YDqi0uGoKIGkg07+GoieTvBX0pXuvFD5c7ZJ3IKc=;
        b=ap9a4GbjBg09LUyqOs4h0+U1/ewN/Ahf1RF2AOmP9z57E6MLBeMgeZDRizrS+BEpo+
         qkhZfeAi66A/xMu4Uiysc2HMI/W4bSGaXxFNS+KG62bxGVVpk9PxCRQwdB0O1EIKIFaD
         GUXT4pz4H9slyswbqJfQDUqzhLwQQkjqFuV9s7/og5mHEcJ77V+PrV/ksyisqvPIa4BP
         9vEHFsZnVgT7eKOrGw4uG6koYpyNSOZe2mBGxcFWcOvsFMy0s2L0kalSMVXwqXjhfltV
         fO9xYqAb1VMlPQliilrd0p66BWHnhomEBup7AflO2juvgK0uIObGzL9TlboiwAoypjCS
         w+Vw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793643389; x=1794248189; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T9ICWzy7eh1ZDcwlW7hKp1lrYbcuv/hAuIABl4o9hxM=;
        b=vQc0W/+DON8/gyS/8D/4P5iwM4++GYOGiW2iDmgCOPGf4y3QKD25eus6DJjarGVLDw
         juXvfuY+CFapxC4LezZu7/S3qxxw8yTE53rFcBGb7Xy+dqQAK1exjCu5Yj4bQ6wtiSZv
         A8GUxil7hxggYPBIuGIxLjZ3Y3+sJH5YHDyX43OkQaIATH+vUNY5jdMv3ojlm6KmAHGf
         9i8A5ADB2DCHPiCYTwTkz7w76t+DPhBMhg+PSRWKChVpNtIDP8/wu867uyI9+lFXeZSg
         PtU6ZQHpVp/XLSG6IcQqJSUuoXPmt3r3tLDaaLFEdTfAqS1js3pjSbICR1L4T4i+SnGQ
         yaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793643389; x=1794248189;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T9ICWzy7eh1ZDcwlW7hKp1lrYbcuv/hAuIABl4o9hxM=;
        b=e2j6Dq/22kQ54bxPjJRxQusnluCtxXtqtGEfIJYN5F3P5NI4Si8A8ORdQqh26ejSEY
         Ik0i/zrwieE+tBXoynw1M6zg2wnrfGk39APcxw8q+B7U7wWEfTqcZsjbTVtGcYBMteui
         qiWI1hU7raCE0BBEdibOfMu3wajlpfKt2FzsWnlACth7MH9UTdzRiWzzzUk/5F4GFCSQ
         VjZjO5vsGqDw5h5h7fkhtEXH6lpnMUBNcRuE1uZ4NTfdXcK8UiMndmZB8Sswv+s0iPYr
         1r25weJkSz10lUvC3yyvibYPSJymwZNm8UihlNrBCMlClIGGYHQuPnY4X7c250jWRuu4
         KEaQ==
X-Forwarded-Encrypted: i=1; AKwUvBzDXtQgE1o7zYttDdW9WHf9iofGosC/RAtLtKJ1MFwuSS/9bWPomJtWwJPaB294gPqMhaYr4+69mg==@kvack.org
X-Gm-Message-State: APuU4Z91Z19TeHan3qK0X1RIJYnzueAaoLwLuGEnTDT7drbUChCSPQMJ
	e59N7Vo8qRZEFAx7E9MY+wUJS6BqZbd5ucGK+kVTPfd/9IOXR8b/oCm95ZhJvjJHfiTXhJojE28
	424ZQKdlyZ8twyypWxfmykmMCMUBdp8Q=
X-Gm-Gg: AYBFou1oNe4XqUzhrCtXQbLheTsR9q6x56iRpCg8hPTkJf7VD9vK+R9N8kmwOMCbjLB
	luV9QiYNLtWKNFz7uPvhaUEmEITG0FJ8NFctStYTBRST1BQuBY0UHjLtlvnFIkEVQAKcecKDnPe
	WylducDcCJjqgcnboq9vdzlPDmtNoTbFI4fZbFLD428VH+8qa/6xPhNyM88T8oWKF34Xkgd1Avi
	FClVobinmACOnZo+1o3jG5P0FFMRRs2D9qcxw1xJSYTDxahwhtU/ZBUmuxNxbWHw6ZeZNDqCKX0
	mQjqMgWasywitguUoR65cpuzTsGzgHj6MvA+ZEBj0rJNAYywjvcAj/4Er/FYRqushF/nAy9rFsm
	6AHUC1c7zV6jRpxaBzpdcytM4xO7oqxye2LUeOUMFmTNrGOfIaAoo5NMqXBxjcsaaR3R+Zps+r/
	Kl7B8qffY/
X-Received: by 2002:a05:6102:e0c:b0:7cc:2bb7:1335 with SMTP id
 ada2fe7eead31-7d07276121fmr4390550137.33.1793643389113; Mon, 02 Nov 2026
 10:16:29 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <aui3TJqadHUv-4RW@tiehlicka> <20261102163014.237806-1-joshua.hahnjy@gmail.com>
 <aujCcqKKyio7oZ0x@tiehlicka> <CAN+CAwOwRJUDXHj0RMr4p2+sdA1V9bX-OgOH1PpER+u_cB2fAg@mail.gmail.com>
 <aujSP_sfbasQaKu7@tiehlicka>
In-Reply-To: <aujSP_sfbasQaKu7@tiehlicka>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Mon, 2 Nov 2026 13:16:16 -0500
X-Gm-Features: AclHuK9EkEv8FL6xfP3eWXeFQa1t-cPp0lrx5vZ8E-g9cOqfGbbE6u5P1MgVKZ0
Message-ID: <CAN+CAwNVuxqHxbaEuu2n8BmUtXhuVeX5v-v5Gu7eegyV0sT+=g@mail.gmail.com>
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, Michal Koutny <mkoutny@suse.com>, 
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 36d65k1k7dkkwyk3oww7duuryycyqeyr
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1B6EE40016
X-HE-Tag: 1793643389-525569
X-HE-Meta: U2FsdGVkX1+i5j7ljirwwv8tmGecaNYXO7iZEaDrv/JVUk+oDVCpQBA5jT1cmbntw1TXT3oXl+3+HI6vSaC25PzSfGJWaHzmyuNf6mV8gc0+iOZaha1+S7wBEDzozSNuxqSONPwPOKIO/XdhGb21+zQPFRkcXIcOLvg9bmObCi4pkOf7Gc2b4NXSSY+HHDlz5vYMonaZM0PhYRsuVcJHDeEPLFyiaZWsrowJnNHhdmQEgGm+M1J+RoA87v5c0paDP4JNvrsF9icSvMbV2qAaP91GQQaaxBdb/KHmPsVJnTNGGj+fjx1/Ve3U554TyWF3EJ0xq77X9mSaFbZKqN1RcKt1BuQdXEoIphfnQpVQ4KXj3aM+MXnIxkgr/6gfGLhsRHPXCaaEfp2CEC8Esw5JY6ZJChLTQtowl604q7Xu62Jhlc04UHZ0Qz4JFEWa5TZo/Wyjp8ihW9a0rvO/g1vLXIM7NrThCEdf452zxJI+1BoKTU+L9cPuh8O2q/eKynvNIkybjRNi15+/uL5B9zMh4xMl5yB+4k/7blRzsDItJM6vC+CNbkLc+d/dpsnjL7YIDYZtMbN19GQaGCQnW69wjrcxc0gQ3UuW7a+sRog/+G2mYyqVVD9xvBNuC1qI5URS/RThcEYPTMt7kNfJBm9/2ME2BuHG9EjJWAnz1OvKxZktw60/5c+KZb/Mu8dgdKW3kCiYhsLrdaReTJFlqLOO0rvHsS3SlWI2wlqFMkna9TdAI1d+9vaiWE9OHzFkYR/8c5jWn9dxWS1Q0jElIXAIBuTgGvztzgjSTKzDHAPDXuV52GLDD/+1MKFuEyp7XrbyKJIhGxviWfj+ekTHGCByA9479cwx3vo/DAbA4HBi9jM+oi1T+MZVFkYAOQJLsfkW/wq++DIcx5mTr4IaY0ArQsijotyiCsGLse4+ZRXErgPCaW7pLaeD3Ounq04nGazxbXKIZWqy088yVgCL4sX
 kg3GNJFU
 Woqw6hDUG++OL9v1xETwfKiHZl2RH5wPIrWG0hcHlDKstN7lxeLZCClJtEI3IMjmAtmvPPt2xpB06Xi1A6UfssLyN2cwG4CEXnjDx8oX6QNVQvmXLOd4EU76UzZ5Lx2UM7kG4xNecarygBqunPg0hBoJVFeL0S9aqpFncNQxNB+lY9ZTOphxWu8/2jXcDUohHQrHXkZi7eZmp0fksLt9JgoBf7w67RLdyhxaWhqzJyhlAYt3+VO/Xynz/RjIfxNPno+Ef/rSQocb9El/KGDt5QGHWqmxt6Wao2QCcJkEW2K5NJ4B1NVbhfDLf1vOF+J4yJ3ZasX9m42ZrRw8BncAwtgNc7xbGxYCrtelYGmY4jqlQ2Pk8tI53WczgVz00tF/tHlPRFiOc1HvMbaEWqUFuuaHBRPOncfLeJUV0FPe2uFYzuhLavHOdW2zCebs8DjIEiNVk6nuVe8fJji+CCUYDX1ysPgEvzYtRysCBHm+MVItZLBKKBSxoxHxfvE5ZhYxxmxCnoVdc7RJAIY+tcJPBo7LUIcHoDhOHMQp1Ce+NZRMZwqyk4Ssi1ScMTx/k7buJqRotTm/UyrQA/4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 1:11=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Mon 02-11-26 12:40:33, Joshua Hahn wrote:
> > > > > > Personally I am a big fan of how try_charge_memcg looks after t=
his
> > > > > > series, what do you think?
> > > > > >
> > > > > > > Quite honestly I am still not convinced this move
> > > > > > > is the right thing but I would like to fully understand the m=
echanics
> > > > > > > first. Having discrepancies among different counters just sou=
nds like a
> > > > > > > potential source of future problems.
> > > > > >
> > > > > > I hope that I can present a good argument for why this is not a=
s
> > > > > > concern as it may seem initially.
> > > > > >
> > > > > > My first point is that the memory usage counters were always fu=
zzy, as
> > > > > > specified in the memcg v1 documentation too:
> > > > > >
> > > > > > usage_in_bytes ... doesn't show 'exact' value of memory (and sw=
ap)
> > > > > > usage, it's a fuzz value for efficient access.
> > > > > >
> > > > > > Secondly, the raw value of the usage is actually always accurat=
e. It is
> > > > > > just the stock portion that overcharge the memory at times, mak=
ing it
> > > > > > seem like there is a discrepancy. Flushing the memcg stock imme=
diately
> > > > > > bring the counters to their real values (like what happens righ=
t now).
> > > > > >
> > > > > > Finally, this is a change that is only limited to cgroup v1 use=
rs.
> > > > >
> > > > > Right but is there any actual point in adding caching for memsw c=
harges
> > > > > now? If you have a way to opt-in to caching then you can simply d=
isabled
> > > > > that for memsw counter altogether. Fewer problems to deal with, e=
xplain
> > > > > etc...
> > > >
> > > > I think the problem actually still exists, unfortunately. In fact I
> > > > think the issue becomes bigger if you remove stocking for memsw.
> > >
> > > Yes, you are right. We do actually cache memsw through the charging p=
ath
> > > which charges both mem and memsw with the batch.
> >
> > Thanks, Michal! So it seems like we are in alignment on everything
> > except the cgroup v1 implications for fuzziness. FWIW I think nothing
> > really changes from the userspace POV. memsw and memory usage has
> > always been fuzzy due to stocking, so all this series does is to
> > change "why" and "when" the stocking becomes fuzzy.
>
> Right. The discrepancy was not so obvious but I agree that this change
> doesn't fundamentally change the picture.

Thanks!

> > What do you think about this? The other alternative would be to remove
> > stocking for cgroup v1 users completely. But I am not sure that is a
> > good solution either. For the record, I tried making the stock tied
> > together so that they refill together, but that was a nightmare in
> > terms of added complexity.
>
> Nah, that seems overreaching without much added value. While we do not
> support new features in v1 we shouldn't cripple performance for those
> users unless there is no other way around.

Sounds good with me, and I also agree here. OK! I think it seems like
we are in alignment with everything. Let me spin up a new cover letter
being more explicit about everything we've covered here and send it
out soon. This was really helpful for me, thank you for your time
Michal : -)

Have a great day!!
Joshua


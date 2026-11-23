Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A33606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=V+lJjfc8
Received: by kanga.kvack.org (Postfix)
	id CB8286B05B7; Mon, 23 Nov 2026 06:56:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C518B6B05B8; Mon, 23 Nov 2026 06:56:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40FB6B05B9; Mon, 23 Nov 2026 06:56:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED6A6B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:56:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 255CC806C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:56:46 +0000 (UTC)
X-FDA: 85466232012.23.662E2F0
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5E952C0003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:56:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=V+lJjfc8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435004;
	b=j66pA22/O+BZsoh43w41ap8bADsLjO+3wn48Oc0goP9Lo7Nww531inCKtvUqJYcUX7/1GG
	uX5v9gw1KbXK5l32VJQayJXFhj2End2cUWJdgEeRqw+QTtajkaYkOU9B7lB5BoP+x8qzh9
	/Vkv51FFhiJjtSvLlJg+dJdVSX6A2VA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJlmpMMEeTrTkXIDblm/53j4ojpLz2OHI/cOPPGH9Ko=;
	b=mp94ChOkiWKoP05b1d09UCaWvhV3gL0Q43LzNUeHIjOCgw1f8hJZc8Iu/KQSdhkGImYP9l
	x5nj3hwcApgNX3Y+cQougx6c7EwbD5i1wslbzWRSmtcDFocccGUsAsxaSva71tBsY+AMp5
	BW0mBtXysHYPLrH1nh4mMxoHJZOvslI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=V+lJjfc8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-386ab9ab619so2027906eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435003; x=1796039803; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZJlmpMMEeTrTkXIDblm/53j4ojpLz2OHI/cOPPGH9Ko=;
        b=V+lJjfc8XT0x4+optDtaWyuKVnAoM+pC0bpG3p9lNSVsNcVdORjONhmV2wpyLJTzg7
         Lah9uwOMzom3WWSKwep4HszqrD4fsUNbw9XLMEQq0PGv6quLbaI4x9rthlV9m34BUAAF
         Y4+V4VXFmOpUbDLViElX7uCWy+ZLrS5yIZ20Ahqz3MRqnCP8vgauKc0Ta3Qpb/wLJg12
         pJvK4UPMYAQKRLk2Gj1T023yc8V573bIRkW+NmmUNkJ4J2crdy/DwuZ6VXs6oDLGzPXx
         /X5oZGgvtq79IBOf8bYL8X9ov+MyS7l254aeLQg5bMLBGtbVlZVilhVlZYTP711KncpF
         t1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435003; x=1796039803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZJlmpMMEeTrTkXIDblm/53j4ojpLz2OHI/cOPPGH9Ko=;
        b=k7lgHhzjH8KyZ6ldoDaBKdrWB0lFqdNcHN46o5jQq8HGGdnTsysFqFHTQ47zptq2aU
         LuOC43kaoPzGwPLF2jqnnd6j+0wfG1Gb8IBFnZjiv25V0pR53MYgYnOSjDi/Xeh9b9G9
         JpylS3wH9craiIwnBurGI7vGheEicfDsggSsiDa5MXU5nB3s16wluO6q4lbdUB75HIBu
         m9CIfpdO0MyOugqfq1WBtNrpPcb/s4Tt6UjYUkKD/CqsC3UMbrH5x4AOxRldr7e3Mc/6
         IXUEtF35gS3OhEzgrEPiR9pn1rIXBRQN6kwG1r1p2Tq4zwH5w2lQYhNgrl4ws7kb41RP
         0o7A==
X-Forwarded-Encrypted: i=1; AL+hErGzDah0LHJTGGs1Z0FGDueDvIlEY4SoJtQDmFOkY4wPsXxClvZ+MaemR9rwocMx7sdTvo4mn+0S/g==@kvack.org
X-Gm-Message-State: APuU4Z+0lWOeBlN/a1X6LMMI2EBl2a1lUAFY+7XLqLDKEl3Q+n0RKk+7
	aFYmTTJfuvzdPQpR2E8ayRO6FCp53Yoc8bWIUL0I6QXDI0j8e3mVulO7
X-Gm-Gg: AZFdTZdNBBo4rJHtncTsoY50ltXGDRHkBmo5AuFweqFlzhCcGusR6ZdoGRV7lSJw51z
	sViEDH7YCeFLN6gu4nKQrl2XsA8xJcGxE05vCLCr6BPtJFmoCGE+0W2KTcjszTNsbBLqkOqXZIt
	jjUEpS3We3YfwGr3y5Hz4B2GMfq4osWw7YhjuNOi6JTS60/TsAImNDr7kGvG5z/UUbpk0NAE2NW
	p7WHWUPgiySuErv1IgsYGvJQorCb6vJ3F8MWw2L8SRCCPzZAoOU2OD45raTuEak2BGjFyKJ1Swg
	INB5cOqLPHNHfc7gEHTV1GKQXrjV/HY5ME9O6+VOJH9jT27ZdsMk5x5ojEMdcYPppHIDMNfjClT
	/K1qKAs7URfLsRzJb1t6rAiKbGiLHzyN2hmLAryWAYkAQtXp8YNfPl3VVIN6V5TwWdA8Btsd7JV
	PdoaT9zZxj1Y9VxxYl8s48PTLY8/9r5/BcFvWEFvuKiUBcU58SEUzUJZ5i02X7APNFG+6Mge2Jm
	3+pkufs0eCv8Ndk/a8+bsHRmr2Rxt5GhCjffrYPDRkVP0vxrHkjgq3rFu9LobPqAk/0lN0+GmHG
	c4keAtyTcwfY0yTL736SPjSwJ2/aRnu8I5jSpLo6jvxo28HXyiHPiNoKX6fyneHtE8CT9fgjz7/
	U65CWpuoQVdX1Ww==
X-Received: by 2002:a05:7301:5093:b0:36a:31b2:8643 with SMTP id 5a478bee46e88-386992b3f3bmr8479130eec.38.1795435003131;
        Mon, 23 Nov 2026 03:56:43 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385672ce402sm33541924eec.16.2026.11.23.03.56.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:56:42 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 09/27] Docs/mm/damon/design: update for report system
Date: Mon, 23 Nov 2026 19:56:25 +0800
Message-ID: <20261123115632.8842-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-10-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-10-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5E952C0003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: fymixbpn9inoudyqfw6naas3pbc6dcqo
X-HE-Tag: 1795435004-777068
X-HE-Meta: U2FsdGVkX18/POHMuHJr/2G4+nDs46OH5k34ZWH/iedyFTPyOqmvUu8AB83MuFgMgrYVUmLB1kuZ9k0IdWiBMjYlgPz7p5L2oOFp0xFoyfDtM4KFfFVSPL2v1QZHaB5mIFAVslv7aalx5PS3HBuJlJCm1OI2ZSQ9C1QxdX/nnhc//XAPQ2LcGmOnvTVufmWVlIvBk/8itrbzgNUUWFeei4N0tC0zMIvKJWkt8a81o40KEB7cM6Si+MpX22TykTjtx/lHhqac0mT8RgF9TvBFq66LO3w0cPObc2Lg5ZOrE2R29CdEglMRbKzpK60iVImY9WtkI6+HFtwJkIyFGkqlW239drVShwHxrfnSsESxpZF9cxOmaa/cysYInhMsRVVnnJEhRMrma+Pnaw5ORch7szKHRU4E7mTGTJC9ZC0/e/hlwqoIgJeBFJnVL09P4hLV2qkA8ZaEFKQqmWE1IQhAetcHgLMTM/BCaT8GLWK4mddndDCcAyVLQ2OmwE6QaUJzIUdI3NZTKOy64Ive70LzO6x1mxvpcNB8XFRoYjIjl2T6PpWAHnRjeL2ncRrj/pUGn64KGThWZbZeKDBnv8AOp4qswk08YTY5V2iDD90zvAqLgNAlrGJF62Bjw2mqmZ02y3/TI7VnLjryLjFgVpc5yviJZMcZVifJGbE/XUDv0Yornu09A8g6Wo8MPrKXyYtLxKsGxufXEw8Lxt5pJedwMnmebBs24GHRyTMG7nyKmhNVTeSwfWA9XaMXmf29ja5nVNqwo1dLggHc2+2cyqoHlHgw7KJ07fx3VS9O0k/9nCi7V+qQi14z/4FwrWzb1gqHnjGW+K3St+SmkRsfeRGpz0Fkb258JLsuBlHYSFdRuANu+TkTwUOSNDpRv+wUUYvc+/yOWy+khIa+NaK0rnz16iJPd5B1UTKXPqk3J5n1D/nFX1p9+L5wL7Fi7ILynrOBPwkf00Hm6jG88RnyOow
 RqzY7wkC
 qduCHBoyvkqE1xAf6XjKmAYoCe8zpvmD/PwgNM838yktSrueQUsDcF9utl0TqM/xCi32O/f1Qhy7/ED2fi/KEg6zFUYdEuCmqIPULXr+SafzSzvuLQ5hb5x0mZXRWRUvnjen2G8aNH8QyfPOyS0aWK4SeL5lEn9/DpuzuLvE+n8zPXxrtGe+rDnKh4OUH6I0BJqFhxGPIgHU0M02dy5Wp2t1kVhDYSGf8dnkX+DQVE/lYIRu4TygCESyAkgdzA2AGSaBg1HkHHu66UHphaWtV8A/fgh2iEdo7AWXAqVJ2A4AZm5l0ioycnmZXqnBfz+YP3utmnLzqKklTYl+7Xkvi51zgH6fDATgri4HWbApu4MbiIR+2z6lu/KykfdWekIiMQPI50d/vB+HCWuxCGsQsNKGsZFGz28DHqh7ZuvKkHnCuEjQet/6fNigFtUHBlHvWQsHrXfyz01YNbza3n1Ko0Z9gMbf4i/8RyPZu/xUEOi77HVC1tS/axPzywb4sbwsnDsk3rbu18RCt3AsjJ/szNe1DstQZiwf4uviOOGA2aGqbAETCHCeyseZtCLzOBshoVfvBC2QU06azoYntugeebCMA9y+aHAhsoC9oIblwI//Y4oSv32w9n0SDhVpeqfYPjIqnM/AiXm14Y4IIHZVsrnZgPp/nSiS54ypMi2Mp6VDfRzmIHZPrOLmYjSqCfucOrOIKVnGU3+HV8mlYzKzR7sLvCe8QIaxrC3V66sH0ldZXBR8W934jkkbOVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:53 -0800 SJ Park <sj@kernel.org> wrote:

> Update DAMON design for the data attribute report system.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>


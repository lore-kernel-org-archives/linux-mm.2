Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B098F606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 07:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fyeN6Hgb
Received: by kanga.kvack.org (Postfix)
	id BFC766B05B0; Sat, 28 Nov 2026 02:40:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3946B05B1; Sat, 28 Nov 2026 02:40:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE93D6B05B5; Sat, 28 Nov 2026 02:40:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3DC6B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:40:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E005E12042D
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:40:24 +0000 (UTC)
X-FDA: 85483729968.21.8BA8970
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2515E1C0003
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:40:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fyeN6Hgb;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795851623;
	b=vt06lmUfSevjBQUZVRkiOsCmLD51vI3nHMnsnwwpF7VvekycTRWoC2U3dbINuo9xcf5pH/
	fKCAqZd4SYPdFBY8lptlg8aJWdjo5YhmmJCByVjXURBYmrQVoBasU6Zem+e5NKjjZXwRWM
	ELe4oCWVdrbqGqNSbynDMV/yRU1RxHQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795851623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sWrlXEvllKA5pRtJLqxc6tJXfxKMf5ArtU7M3EbpoFc=;
	b=8Zeu2TEv2hzof6WtzErLF/bDz+JzCJRe/YIjMCXBo9j3jxPGyDGuC4NZEv1rCHxtla0FKp
	UcE8qEz5cz3uarGvbfPDIWWFYmXozBESENv//8qxkst8a5Telfv9enL/4R5El/5MKvNFUN
	/maBIJ7jSPai+YtwlY5pvr9oSf121+8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fyeN6Hgb;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1a2af4c8d00so10395501c88.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795851622; x=1796456422; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sWrlXEvllKA5pRtJLqxc6tJXfxKMf5ArtU7M3EbpoFc=;
        b=fyeN6HgbVag6/m5zsnyWJ4GzKcdwwGDa/1GDTwuDTUSyvH9m9eUNjwdWeeD3D0/OLk
         Plbgq1dliQNLj+f/BICtpt7KQrz3y5TO/xbo+AQI8vxmagqdmO1ixPlMLcMpMMW9/MQ3
         Ikq4CoCK9hf2we12ONd2xlk//07aHNWSnzFc0pejqCzrRtOP/j/d+Lof7XUfgaU4Uqah
         QUlmb02sf+cPVcIOzfc3W6RGRDNPbm/LSy7sFWDydqTMC7oIdviExr3Q21kafXo4tdVp
         /pwU85fj2uuqe81qQVwO+fx+MdAkrC2bUBEOFz1MKH+BOqF+DA5pbPZ/7aQ5kEYEU+p8
         zhJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795851622; x=1796456422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sWrlXEvllKA5pRtJLqxc6tJXfxKMf5ArtU7M3EbpoFc=;
        b=y7eOYEjwAsBa5T/o7lUhl8Wr7V5qOI+5wi8XvEDm/PAPUks0rtky8GBsJhUFoWzz7U
         dOUoyikJ9IdiX8CKg/a/YCdgWliJRW/jlnqckvXATkrUnFpHosch4svN0NJ2A5Sqxi25
         LGOWAUFoCB27ScQNNl/wYJ/X7uFqtINMo1Oge+b4nmAxxmo8jI6qSCxQ98XRQk1NGC6p
         2midywZC6b88ITC8oMMh598ep6olrXap6FJySL395MyawDo5YH296Q5+clesRSE4KyR2
         +LVfXzuCupAS/GKVTMlHqXa+cwgT6u4Y9RsB+HvbT5AhZxQfwppoO18NgebEGAlV57kt
         Njeg==
X-Gm-Message-State: APuU4Z+jTMoqY2QGvC0ypnhqccsSncCCHN/MWKnrWiD8Hm9NpcHZfUvq
	QkLclO9Ye3FHCZzmt7ye3w+km2D+wogN1XxasyedxD0SG5FSJagnOHze
X-Gm-Gg: AZFdTZegyBkiPR8MMa03KYNqCrjWfxWOnh7Sms4InZDmdAgpqhrX3A9+mtZbLC46gZ8
	w0IsemfyXWV2ya0V/582KnVL3f4tXQYRGMNuxisGTVVIMBGhVkD7AKlAdOaof+HWkIpbmprDVBd
	o8JLJJtrzqXz5afMnLNDhxZL+bGLtEgACxdQ92f7Ry5ci2oYzM/EAYhJ8Tp2aLK6cOGmq7hpNcR
	ScYHbNlOkT8jWEngD0xujycgjh6H5dpVZBLOlU/ID1OTc90o0VR7I32Cgcila3w2PyKoI7ReyHw
	oovhNIEfEyY/Bw/1cEEcby4PjFItD0Nx41w9p+jTGxJxJ0Ouu6eMxL3kPLTV8Zc3Y6Zrb64dT+M
	eqA5bGw211ERuzioo1TCnULRVaW4dTB+o7Ar79U9+ES+qOHDRW74MZJ3PY9gFHXJslwDqVmBNUX
	Ag2Rot6ddARIQaxnW07x+JywgofMJTurw8d9kVJDN2EItqq6WZJksQICVsYUoKI3N3lqcHqpz8e
	wr6iB65K4jdLo+kgeTx1ndAGxWMqR5ii385dwEnhQsKW2mx7fUmuasYx9D0djbleW2L9zD3TwkF
	fdVXcNEfCkEePsJlubWlMsO5145m05X9fJ/uuvQiFX2kMRLk2qLY+3Z4M30XY0N8GHt2
X-Received: by 2002:a05:701a:ccdb:10b0:1b5:9b36:eb04 with SMTP id a92af1059eb24-1b59b36ebbfmr4118375c88.41.1795851621978;
        Fri, 27 Nov 2026 23:40:21 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5568592adsm60591364c88.15.2026.11.27.23.40.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 27 Nov 2026 23:40:21 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5 05/19] mm/swap: change the swapon lock into a percpu rwsem
Date: Sat, 28 Nov 2026 15:39:51 +0800
Message-ID: <20261128074003.34128-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CACePvbWriHftZbyJMNfZ-09KuK0ZgSMwxEC2P5Rs_zGAknndwA@mail.gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com> <4f355219f202e5fce9e8dac7dee75f3ea7c51d4e.1795439990.git.lianux.mm@gmail.com> <CACePvbWriHftZbyJMNfZ-09KuK0ZgSMwxEC2P5Rs_zGAknndwA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 2515E1C0003
X-Stat-Signature: bo1p5poxy55pr7anz85ohd7gtrbiuutb
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795851623-198730
X-HE-Meta: U2FsdGVkX1/ZyH/2W3HLLtuwAhvl+7IJMe5/dNAcD6CTVrLAVqDjxMi64hwpyz70znAu6h/IgM4qaJ+1cU8jcsZTXBKLGFJCAP4fj7JaQtfjBeXR4ahEoRybsz8mU4nondoVHGGtOTTG5RypvqmV/lnN8iEbim6YzbDie0I201qP5vQ82Ycq0hNDHENrVbQwBOqxJjvP96+ixdQD1MVOcsGcuhjz8WtOux9dCJSVvytIBYEA2M7C6B1VDhymToS4UICQEx2CvQy5LPoLknjiQTQXKjzUQg+hMZykX8KeVXf+8EuVbm+6sL31gVGm7tqlo15suKCHlPOVGMXGpJtY0ZIj7wnMzQKDkq7/2Ua/PNaoWrmgCxukKz+vHrBKLvoVxBvfo64f4UIyHN44bhHAjByQfXKinQ1qO81AFaxYqjdo/im8a608EVKZzkjBRW21GuMWRYwYZ01MkVXMOKHWr89gMhSuZPZh00dXbzWRpD22pWMbF9xnp8vR8GFwwbtboMswWPvna3fuBpGMj38ZQcyjvwCDLH6+QynvuBiqCZcTk2U9i14Am9TSlRMaCq2kXo1SW2B0DcFJamKUBoRR/IKuGcs1pWNRjr2iia/uQ2+T9jrDhFfpaG5+mR8FT3+SnYALKBS5PF6xBfmd9s1MYzlX3qqULTeB+O6AGqRLM3BWsS4o3P/0xC9V4+wEDLjk6f6Le3aILhQekg8SIJkIh5II3UOWYUnkcygtE4BUc1EsixDCxUC8jnoRUVVIBzk1GV9ZZ+5mnGoi2UEw+3WpFSVzjXj0+U3K/SYlfxmxtYfUwzEzWN1SMqVkg9CKJ1x+thsL5KDLs8AxCa9zQpoWJjKB3xMGc3RWKG4wZ3UQocP8L3eMXPsCHVmBoarYn4DDzjZFnMHIv6kYpHcBKklV/SVroNgNt5qYYyidjMYtZHad5zP4YdGmBQsfi2i22Jq1ML3qQocH4cs0pYOlpIf
 f3MNOEQX
 1TTnY+xNfOm0d37EkwswpAbGysMtHw/dUPPJ0rK8wqZQWnowYs8maqwjY6Lf5OazeO2k4ifOIQjeuAUwkcy8L6oSAZ2v0DclJJbHFDTdllEsVt0YrP2h8Cwo9pmkn7TUIz2k93Gu1czlH9OWkT1HScUrEVni7IvAPftTwJwAKPUABQgf6PR1rHevoK5tR76Y3OCzSBFk/g1/ikqLrWRpF0fLGeCgQjSnFt54/eveeBFjXpzE9qAthL/K1BEnycLg9Xf1xCYMDhS24aqBVFqIBR/r27KIrj/yaJSQdY2YuD83Ep737WRvzyqv76DN1fNaLbY4R0CyRtQxBrQoBr5pvxhknC1YcdFzwoO0YLcCbJLU4feCJW/5wC564I88RK7DW61amW8t63PhR/aN0l+TCP28zLn5hHUkBYeQKGNecuvWGCtE1ddBqbjhlRJsVhgCMZ5Ime7quiwbIBJOtmxVeHd5v79U+aIGszOYbdwN72pvztnyPcDHsmvIwiJ4Hta5ZJbNkQjSXwECZ6/PXT+ufmRo12oJEeu7QG9wZ0b00J5PZGTYolOtkbzK7CYIarILsnTtz9AOReeUfRNWq+g5I5twD8moxP2qdeLsoY3t631sygqE29R2cQzdPjSPn061RbIcn8o+OOauPQK3hJHWePmGPVSbrA7m961zN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 26 Nov 2026 10:03:25 -0800 Chris Li <chrisl@kernel.org> wrote:

> This seems to describe a lock protocol change. Very naive question:
> Where is the matching code for that? I can only see the spinlock to
> precpu_rwsem change. Does this description belong to some later
> patches or state facts already existing in the current patches where
> there is no additional code change for it?

That's an existing rule, not a new protocol in this patch. On swapoff,
del_from_avail_list(si, true) already clears SWP_WRITEOK, sets the
off-list bit and unlinks the device under swap_avail_lock. What
changes here is the outer topology lock: readers such as si_swapinfo()
take the read side of swapon_rwsem, and topology updates take the
write side. It isn't until 11/19 that swap_alloc_entry() holds the
read side across device selection and cluster allocation. I'll make
that distinction in the commit message.

> I wonder if there is a way to forward declare it so we don't need to
> move the definition.

No new declaration is needed. I'll leave swap_info[], total_swap_pages
and nr_swap_pages where they were and just update the relevant lock
comments.

Thanks,
Lian


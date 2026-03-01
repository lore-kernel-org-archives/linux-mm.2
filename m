Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAFC4FD0047
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 20:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77DD6B00C4; Sun,  1 Mar 2026 15:35:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50596B00C5; Sun,  1 Mar 2026 15:35:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E2B6B00C6; Sun,  1 Mar 2026 15:35:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF52A6B00C4
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 15:35:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F7DC8C425
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 20:35:27 +0000 (UTC)
X-FDA: 84498649494.01.4A8D90E
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id AC329C0009
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 20:35:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XrDtWbqn;
	spf=pass (imf10.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772397325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=X8t1xtrWKi4UjVm8hQsxA162gYI4MNNERdKjajNTEYk=;
	b=K/k+u+6sykOVIWXKo5gfb83N+DXsWef4ddL9zA8a4VuFONOu8SGSMHgiq9qgwLEdZjpj15
	2H/nljDOfjdhaRO4zSF8ZOL5Dt09MF3JJfNIL5NIlEwZ4blb49ozi3J4xwwyxMuh6L+e3g
	0GW9XVl5qHpC9GRiEckMAG8wGu91vKU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XrDtWbqn;
	spf=pass (imf10.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772397325; a=rsa-sha256;
	cv=none;
	b=T9G6eNqC2DjLbgKiyxBnYr6vX/BKvjBFHZOM0WSJTOmnRY0FWDAYXaAJmE0Rq0CsgKU0+E
	LFxAnAIY2WR/SS2IA/3zmZsT/JFz5w21ckHgx1YZB37KPCuEOHXo4cqLjfdr8tztUSDk87
	shor3Yd5PZf5Wvonqysf2xr0YDTt3jA=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ae3f822163so64265ad.0
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 12:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772397324; x=1773002124; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X8t1xtrWKi4UjVm8hQsxA162gYI4MNNERdKjajNTEYk=;
        b=XrDtWbqnfio1lqsCJ5ItFDqk5//4GN5e36scefnZ0Nv8wm0/LsPx5yzVKBYlKor0hq
         pLMFBQgh5VvzTSFfVHH5JA9XJjFB5lg6Hu0IkktYGBdJ7Uhub6EnghPtdXsc1y3z7OJ+
         0FJ3ly/YqdxKEtXrQrkk1j3UuNdQ/383nX4wIOubV6nOWICWciRJUV0j7esA5OcHoHIG
         yKZ4yxnUa11ctTpVXkgIP9AbIgRsSEsLI3kTx2GSFF3lQDSNcKV13dBCdwYruyc9S71p
         uSZ/bMmARnRS4XplBxf+AvuvDoYi1xk+njx9rTSUndKM+3k9JyxkRJRBqy9y27rFgE96
         Fs3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772397324; x=1773002124;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X8t1xtrWKi4UjVm8hQsxA162gYI4MNNERdKjajNTEYk=;
        b=rLrYjgMMTOFZjiS68frRaaGJ+cpaOXh8AczkueRsHFDvkg3r1p4zb3QiBTEqH1q+my
         dBg2LAM90yVZOXuDKAl7Uwo9xbJwSMNoGiRT8Uw42p20Q4pt16NyWDXPgFzKXhSRpTLj
         qXwFC+gWI93xFnEWR06AYDnxYLTMuCBcJiAm3f96VTbLNxX9jdss0OI3GQpKd737Cpbt
         vBOWHbXOidIzs6h8rBzkZ5y/lQ/O3c1WWUoFAdSq8z4xMhwSHcdtUhQfEQaEF0S2F1y6
         hJU0ztPtAXruVsEaxapPw0dKtQBwGBpng5+OR0Ju7NZf8KcY9TthPxSoJab1bK8vbvZ9
         DUdg==
X-Gm-Message-State: AOJu0YzO6tATUoEtbSWlrP3pz8uiAHUAGApf+U7/CDL/9GmeWBdvJtvG
	GJm1wotTC/yQ2ezJNg0gRLpy3OZlrWDgrmnUBsH9vAg+VXHMiFH1V1eoCf1ys4Jyvg==
X-Gm-Gg: ATEYQzyDrWp9jfV7UTGX30XLGao+TXmjZBpsNkHY8e+9EVHFv8OaRl2UhvMpG7B2EYl
	AB8uu09oh2Ca52qLtODDbqFAUwOo53BStf1vqXz7By7opFHIOfUdf7gDa6r3fpjaz8dlJ71qLO6
	a2/ttJ+5QuO1Zlfukb3nq2wriRgHb0bLdVThJ3aF3FrK56rOJ5evJQaBa7qLNJuIFdc6SCGB91z
	JfU9ZI2OUc6otoXqerGAxJgR4Qmg8/qgl7hGxktTfNMoKtzh6ZKVGywUVFpY9xs/KTxqkEg8Hvt
	mLwN1LtUdWUA6s+k+1FZiiugUHyL8QVwsIbDfbcRP5LwYj/vtICkx95IisRMwsLhnwg2xZqmmW5
	oVai8Pn3cnMOgyDGxSZvvk+lMWeTBdpu/AzGT0bMxeKrizkS311rCESx/p/xewiBpMLZt3/fzSV
	IngC5BgGqY4LfhG5xkHDXKbAGsvwY8Bc7+5rC5IQJUp1KMibcABYMPbYCegk7UHggSUPrNWJoAH
	Pi+UUxaDhXS1uVHiEVVglvnkEA5d4ynZ6bEUKC+JGc76HgPL9dJag==
X-Received: by 2002:a17:903:37cf:b0:2a7:87c2:fcde with SMTP id d9443c01a7336-2ae3b50bedemr2338055ad.15.1772397323757;
        Sun, 01 Mar 2026 12:35:23 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:5666:3068:bf22:da79] ([2a00:79e0:2eb0:8:5666:3068:bf22:da79])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739d8805esm11493340b3a.16.2026.03.01.12.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 12:35:22 -0800 (PST)
Date: Sun, 1 Mar 2026 12:35:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from February 26, 2026
Message-ID: <855370d6-811e-5864-b93f-c5bf4b6e27b3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: AC329C0009
X-Stat-Signature: qanncad94ujq1d8mwz5x6xbpdmo1sg7y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772397325-598912
X-HE-Meta: U2FsdGVkX18ur9JWtPE7/3k4/yV79THM4Wvun37oN2iX/PmzUMDQnr6Sg5Zgh1Uq4I6xH2ndVa93UvFwy0FNdJ2Kcl3s/uKvRy9o+VFBo65uc94dcjq+fSAMdJMX8PvRTDB5YPyJBf2/oJ11GoY83VJxL5boMc7ldo76X9aGo9nw6AV3fefTrcTNS53hOQ3gKOOg3FW4pcdq/rrB/Zg1u7FlNL0IZYJ3HnyNTAmlR/lDBMfI1T3n/Cw1PKPL+JlJbv9eS2n8raDjXhFudgRqdIxxLhFXHYd/qQNlVS8YUK7tzncy6M4aHL1ON4dacsYNXac09E9Ypv/jewB3YPoJMaQz7HpL8nOKRm9XhXSC9k86fCQU+PXEJmRIXBV7ZbueOIzWW5ytl59Btokybq9ZNlDDzih8p5aCIAm3XBZHxQJ/x49K7iXtb5adInhKfuBbTB68jzNeHLg1aPRYPQHoxVxdEuEOLgdkPD0nRFvYa0QR2xDYG/HkSG4NPiwZoimjdN992X0IzKFVOrVnD/oyC75tE44mDUJEd/fowljsyHV8deoHK5cpB1JLdiJ6BEkJ67pvl/GyRqMs2+d5l3pMT7MerlnevvLKZMBSPzSiGlC0m6nn6sxZidfUWbU9yMukuKffWcWvw7th3JkOoJmTWJtvJtPT3pfNsjGloZN71O2oQwNRVdh8uAyIq4PyfHTHVhBkNnkcsnArZ3k8gyhD8P8cHU025RlK9xmXZYHiuhNt2feDFw676lkXfO965AVMiJDQGgGP96zqauiX3tJuC6gVRsvXkwyvOeb4JZm5lbPS3ZB8+OyUtuw7ftgcGHc3LcKSusMKo6ERYIZzphkA7A6/luM0aYLJ8BZmT/K1V1h6XY/vS6pUnJLxsqTLRVIX5J/j1fHvzMRZNPCuLTWVqLhIYsqvmMjfEfYFmFAn9yhtKpViWELpmhPd3/hphC+K8dr6ivKUIo2hPB5QcoL
 QhfXAKtl
 eqx8j2PrLRU4DMpEri6IKQZT2dUii3g+caNA7EiKFxkiDRSy4fQ73o9hTENjwKaCO+RTbZXIlvKj0AiZ+9EWa+g5e350qdw7rzDVwj2PVeKDprfFs7FoyU6CUiU/tdyPsALz+Z2ie6KnsWKCm0nL9DHjo3pneIi1G8hBsOJqJGiyXZSwuV7gz80W4fy8AD5gmimLCS4cyBpgul9t8rE+kvnbyqkueXEbMKD9lfcs5RQiQsGa0meT3vqrZqg8AfsAxQJ4RIDs8H2Ql7JUiqsXGL2L62SX424TJSVuK0fIuJdQLXM6bAvknpA7oXE2jSw6Ppj8tSKaY4Vx+o4bhGA9CsTWI7v48qdi4kPvp+xLupofQyaA1kDwlIE6CK9h/GNs2DphKGKy1pr8xw0qZXQUmzZeZmwnU/zYZttrV6JPtf5vKBx4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, February 26.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata provided an update on the status of his work.  He posted 
redis-memtier, graph500, and NPB-BT numbers for the RFC v5 patch series.  
He's planning posting v6 soon with a new set of numbers and in that series 
base pghot and hintfault source will be non-RFC.  It may even be possible 
to include other sources of hotness information at the same time.

Joshua Hahn noted that he was looking to test Bharata's series with his 
reclaim fairness patch series, now rebranded as tier-aware memcg limits.  
Gregory noted that this series would be focused only on top tier memory 
but extensible for future use cases.

----->o-----
We touched on the CXL Hotness Monitoring Unit (CHMU) and whether any work 
was on-going to abstract this in upstream Linux.  Both Google and Meta 
were not actively looking at this.  Yiannis suggested Jonathan Cameron may 
be looking at this for qemu and testing.  We concluded that not having 
CHMU support upstream is not currently holding anything back and it might 
be addressed in a year or so; it might also be solving a problem that 
nobody has yet.

----->o-----
We talked about LSF/MM/BPF topics that relate to this series of meetings.  
Joshua had proposed a topic for tier aware memcg limits looking for 
feedback on the overall approach and interface.  Joshua wanted to raise 
discussion points around actual multi-tiered system usage in production 
scenarios including three or four tiers of memory.  I chatted about 
potential future use cases but also focusing on the practicality of what 
is possible to deploy today.  Gregory suggested we need a better 
definition for what a coherent tier is given that NUMA nodes themselves 
are likely insufficient.  Managing nodes in userspace is likely not the 
end user support that will be required long term.

Gregory suggested that until we have three tier systems to use and deploy 
that we won't likely be able to foresee the problems with that until we 
get there.

----->o-----
Yiannis brought up non-temporal stores for tiering and the possibility of 
finding time to work on it in the next few weeks.  He saw great value in 
this from the compression side and was trying to determine if this brings 
value to CXL or tiered systems in general.  The idea is to extend 
migrate_pages() for the demotion path so it uses non-temporal stores -- we 
don't want to warm up our cache for cold memory.  Gregory noted that we 
want to ensure that when allocating the folio as the migration target that 
we would also need to make sure that's not in the cache for this cold 
memory.  I noted that Shivank from AMD had previously presented to this 
group about enlightening migrate_pages() for hardware assists and using 
the "reason" field of migrate_pages() to differentiate different use 
cases.

----->o-----
NOTE!!  Daylight Savings Time starts on Sunday, March 8 so the time of the 
meeting may have changed for some participants.

Next meeting will be on Thursday, March 12 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - v6 of Bharata's patch series including pghot and hintfault
 - LSF/MM/BPF 2026 topics to propose for discussion on hotness, promotion,
   and memory tiering overall
 - tier-aware memcg limits (reclaim fairness)
 - Gregory's testing of tier aware memcg limits with Bharata's changes
 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl,
   otherwise utilizing bandwidth information will be challenging
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast
 - update on non-temporal stores enlightenment for memory tiering
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace, including for memory compaction

Please let me know if you'd like to propose additional topics for
discussion, thank you!


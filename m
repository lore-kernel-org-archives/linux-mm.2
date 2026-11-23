Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD92606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 21:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AXzdykSl
Received: by kanga.kvack.org (Postfix)
	id E537C6B05B0; Mon, 23 Nov 2026 16:22:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E040C6B05B1; Mon, 23 Nov 2026 16:22:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A026B05B2; Mon, 23 Nov 2026 16:22:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7B5C6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:22:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C4221609C8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:22:52 +0000 (UTC)
X-FDA: 85467658584.17.6315DAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5A17514000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:22:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXzdykSl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795468970;
	b=sgjrDoVaOckVVbz4WqnQERa1XW7aqGkkDpgZikWH5Yx2++6KzVoT0x0yFhYkWpJ+sJMvlH
	WsqxqqcXXobRypRf22jcaM1bf3y9PlgMrj9GudF2bUmy/TL4DWFXSb7P8yvsgkeljuCsjz
	ApRdwQZvE0hq/tpCc5qos0ohbSM8xF0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795468970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eU+6TDE9yV82imn9cftyUyCCED7xbfUv9FoTzNU9AxQ=;
	b=WviHfjxeu0hFqB1xCHv1Iw76jk8uTHsYWX4uSvAQy5HyDe1ciLkY3NmR+8Zh/YUXgOTcFP
	H7QYOxGB1H1Fmj/mFpbytAZISNfsOmPy9e6DrtR1mGhc0G80V8mBotL2nay5DL04dShKGg
	fgI9JwVHDx/IAtF8wImScAvbSlP3hLQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXzdykSl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB34261E7D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D13B1F000EB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795468969;
	bh=eU+6TDE9yV82imn9cftyUyCCED7xbfUv9FoTzNU9AxQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AXzdykSlrixB4Ol5/wwg5LVbxAPTVXT0ydB610Pgq4ImciJ5PIhsl/680uPtvZGc9
	 cejHShoviTPVdjoG3+p+4tkgDeIDWJvad/73fG1eXA063UDMPN2k/vBgrK5pkAzVXA
	 HRjdFT1Pb7N93/TJBYkm/LFKdtj+zURr1AqwI395pEC0+1IbHyo4hUqk1vlTfAUQf3
	 xUXCHaYFL8knlVLhmvHtlDuUExEblqY0e67oMfxj0CivH40qgApR90Vt3dM1PXt9GV
	 FA2IjnQd/1Yv9T8cVB9M197ijLgwhaPwXozGmxSnhrUFvRfcXYxj8WGhnQvYVWDMOl
	 NbD/TlN3JxK1Q==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93f2049ea7aso279821185a.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:22:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHDuSwomzut+Ynlka3Ty8EhZGqTFp34jOS0jtDHtzynnAJRBIjCivfiBTry3IbzQwDmyxjl+zKM2w==@kvack.org
X-Gm-Message-State: APuU4Z9x9LGaJdSNLJW13AXLMDBQOoT9WVZXe413WxNPB1RiQuSm1+aZ
	NgNamZDwRcwOkLwFPBcuTq+pEhNdED/cjOxRXiKD3yacaqFxP8D4udnXhH2VylKZ+ngZccbKsx4
	iMoQnqNpMqaMsjZDVXl3KOCQT8f3BYfg=
X-Received: by 2002:a05:620a:29ce:b0:93e:d854:4b83 with SMTP id
 af79cd13be357-949ba9b3e16mr2296045385a.22.1795468968646; Mon, 23 Nov 2026
 13:22:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261123135200.4086519-1-max.kellermann@ionos.com> <20261123135200.4086519-3-max.kellermann@ionos.com>
In-Reply-To: <20261123135200.4086519-3-max.kellermann@ionos.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 24 Nov 2026 05:22:37 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y8Meart6rfQ1i1oAm4NoM6YpPx+s-jgdrqgf_VPrs10Q@mail.gmail.com>
X-Gm-Features: Aa3M54rk1a4eAkP-XOuFBhkZSsK_OaOxvXCeyMlLajAigxVYkkkbNjKxH6OqKJU
Message-ID: <CAGsJ_4y8Meart6rfQ1i1oAm4NoM6YpPx+s-jgdrqgf_VPrs10Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] mm/vmscan: move code to lru_gen_{add,del}_memcg()
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: e5ntxgr1wqp6ui694su9wh87b5pmkcmn
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5A17514000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1795468970-895647
X-HE-Meta: U2FsdGVkX184opAcHN2kTgTUpDSExzvxpTT1nLq+tfbACn32fpVfdh8sKzi5FzyGJbt68EY6shGThgsJcaG6BxJ+M0n6c8GnSc0BvOwQA6dRsG8S4IWQHt13+YTRtAhWIHa34QkP3+eQFPwqPKce0xLY2aIk5Pw58AUG7XI5X29Jwnf5pB5ukJP+ahyw87zh0bp8UrTM8jeeW/iSt6ajTRrCqRDdSVCCaSM0t8ZC45uhDNa8+Pylw+jP8kzKRoMemcsrW2yBpj4TIiAOg5i+n4LRWA8Tgad4OVLBOlnP3FUBuT65C2TjvlABTV81EAh5/gXZWi4vrmHN8gbJXgbQSG3uD7avNDM1N9NbGkzvgekwEbzM/HFRoC+pf+j//M7BKjILNOhhCKbMYVHmuOHhU4JEv4jt0QsMe1J/Mpf71GoTvrTalEEes3NgCw2kDe68Tw8BtrK8QYANkO2hbJFWphJMttOfZrZlNHJJNpkr+rJTsSzGnkXcN+F2PnHyUGv6tZ9aZCkzeCCHHLUqYqN/ZoUINc2mq2l9U+38Z6EyX4XDPVe8W+uMjxOd5rJGdLXOK3WfSv7dd/dXA2EIcvvkK/zi8W+WmZArexzTtvcWZpAQjOlpSg0nViRvkOTNpR/OUAgal6DsVya1HTp168bzBo63YZLJK4TzyD42h0tA4T5w3U3/Zvqn5hQSMcPndXEFGwHIeuiSNYEdIT/bMCo4uCV5rOM1i/7++hh13sbZBPWLyfpJFIhepDXX5PLx8IhYdIY8/514QSffm9E9+cFIJKB/6PU5c50fLYe07oQVGALERysn6XzGZ+KpwByUflEJyS/kpybmENQKICdR/djdETR7MyXOJ9y9XO1Na/t5q6B1+3+yoS5y/hhTSIMAV6vqZB5RjJAIgkJ7bY7g77zxdCCzh7EzxEQpjXPE0HI7hqGz2BeIbC/SrNcIYdwBRHakk/NUKWgdF66SYyhweD6
 I67+6Kge
 eh0YRYkHm0ooPsgswnoo8tYXbbjVSQ+/zFC7ab/h0gjmRG7+qb2IxFdWnPOjWguNZA6hfQNQ6rfWWTGwAw5YQV0hwo4WAfwesoKKQ79uz/ABxT4x4L0WHn1lsPbz0UrnyMFUkI7OmDa+hulGGSVkC79DnG+ZLdfa1rf9b+JU9+OufMiy5xvP2wGfUh1W6P4I7Kx8DC/9zteqw+Tksmhylsypy8ByN6+cArcmk2RYv2ft5L2WiDV/Z1k8EC12pov6C6bX6OvWwxGAwbkIbcX6upjYlYIQg6Bsl1eify51hHTio4QdGDj8j9v/Xa/dsTsuBXc3DD8acUPQXmlcLN0kwpat+M1ZvOcrxNZgr/o2P3cuWdnaE5eN+mIzUTM+XnuVAJV0JkBhdkhwvaAzPKmumVoD28FmKTg9FQwXpgARa8xgSq8HEr5JeRpNNDdShgTcdZeQUPABpu5E/K8rdIPl+LdESIJgdJlmebTCJmz6vmQ+Zmh9hMo881+RPcGSKwDhAGpRtWTJ5hn0Q9nSwwzG3zufoSPGbqfESrvBhZ3I2g0R1YyqHGkbLQ/PZHcLsQ6tpyfK6BCzyZYwbfYVQHFk9o8JuasEpRU6uWugAyAGQxlRSCJh2i1Ubhjxi8m3jw6WSg+ux2L5q7aD51Xw0LpJqWDbUjlKuZHRxSN0Mki99V+KsNgkMZbB6RNBuUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 9:52=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> Preparation for the following patch that adds tail caching.
>
> For simplicity, hlist_nulls_del_init_rcu() is now always used, which
> is also valid during rotation, because the entry is immediately
> reinserted under `memcg_lru.lock`.
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

It looks like you missed collecting the tags[1] again:

Reviewed-by: Barry Song <baohua@kernel.org>

In the future, you can use `b4 am` to collect the tags automatically.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4wit5jKGn4L-NDTqzxDRNS8s8-FV3g0m=
5e6BOcG2Gx2Eg@mail.gmail.com/


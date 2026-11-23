Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE80606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DK6Qf2+l
Received: by kanga.kvack.org (Postfix)
	id B99A66B05B7; Mon, 23 Nov 2026 07:01:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70A06B05BD; Mon, 23 Nov 2026 07:01:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A873F6B05BF; Mon, 23 Nov 2026 07:01:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9CA6B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:01:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20AFCA857F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:01:58 +0000 (UTC)
X-FDA: 85466245116.28.E305AA2
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4ECE120013
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:01:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DK6Qf2+l;
	spf=pass (imf31.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435316;
	b=qPuntmxaxCdXejRtRkFvMLz1RX4uVWuJbulZE+yW8wthLZntGRdZy6aF+RhLdmSHd5Xlij
	oieAVbCYuu4KzhMCN7c22Q13fTy0a7RtwR5P09hCrCBG2eWvKLNCZDreYkCH1OzS2a3eRA
	+F95C1su06EyUl2NiROgmXMeTvRg30g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e00YkeKRrjU+Nmoj9deWhfLwl2lr1/3aXWQO3K02B7A=;
	b=jPqTgnsPe05iNOvQZu8RqRQU5kZm2LN7io8PRcWHiUeLFrPlm78Oj1mA2xdQpA+tX5IfR6
	X3ZyxLFiMeSvpsSsDGy6XwgtfDSARUz+Vo9eaVV3pcXw1JhRgKWvqpO0CcDfujKMNWcPdj
	Ur+olbuZWahOEbz6JKbHifutzDKZios=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DK6Qf2+l;
	spf=pass (imf31.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1a2761c69fbso1852502c88.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435315; x=1796040115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e00YkeKRrjU+Nmoj9deWhfLwl2lr1/3aXWQO3K02B7A=;
        b=DK6Qf2+lMWjxViXNj+109J9SJKQ27tUxCop+9EtXXgzfHZjw+7hRKWH51fD2jXSWW+
         bnFMJv6wIDMxqgzVxRw6RaTyStZO6ypbduuGteE6ppC5Ab6JEc0dhto+hNvVoNOMKNNp
         b+MJMUomlukr9Cu7D39DTjWhKbPQVmxITll9Zvexu6URXFP7+ouQa758p3IMarUIYmGE
         sxhojl1OSZIjlV4iAogiB5eO5tWb6mx3sQle8mmYgs6tPKczEgbxjXhDb6dPDWAxJN71
         ceIEaleHorHw749VqtqR/jzK9/pJXbuVXXQFsM/5AYMFQ4LUNrDq5Vvu6qpQgjHWupy0
         HPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435315; x=1796040115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e00YkeKRrjU+Nmoj9deWhfLwl2lr1/3aXWQO3K02B7A=;
        b=JWAJVJBcgZVPcqTzJ2e30EZbrkcgtjkCDQWfej+07nc+HtwATdb5xD2fElF37tuqkn
         acyDRGs/aqD6Rtsc3wSmjiWEQP3etSyBQmaOkiG/IAZbH5exn1qYx3NKbw9hH9ZE3FP+
         /GKLwcF7T+y+exnCSuzQQ14thbIeyN0n/3UMC35ni7F3IqRyWX7KC1jKppV8Lf3Kj9Lk
         KSLCdmRkOrMog9S8AmL27nDQykwEMfhdFFuIOm+f4llulqleGy/q4OwUNS/J2Z5hwcmj
         EWroz1xOR7lJMB2A4c1Z/JZCp60RiKsIp9E20hFo7ni+lbCaBo6/ZwDCy3IPetqebvL8
         xTVg==
X-Forwarded-Encrypted: i=1; AL+hErEMYK5CsMset2CIQnzHUoepsdjRW3haEFpgEBlitcBlZbrXuZnoDWkyR/C5vDhF9TDCbOYyUhy6vQ==@kvack.org
X-Gm-Message-State: APuU4Z+tEc6igDYGR9mE1HbJr8jikXpn8Saw9I5q7/xkfNqIo9FPv2+x
	6b9apwnerNP6GKqBiTFwrYE1YhBo5fZMfzHpN8XGzfVVZYR5gr64Joky
X-Gm-Gg: AZFdTZemXanMpbYW/PoXGnUP/yt7QKH31pGe5YFd+JuMI17nHIWxuOqIhm4HzdRC6Zf
	i8hc/KEaeSwOYyF9pwR3isFCKVv9zd/PNXWv2WGr1N8rGRaOuDm6KftvuE82qw7gjleqAALf8UM
	FCXJR0eR6g1beoU1+mO55X4MHBvBREXIgdmS/cv4wOxsPISc//sKjVGTbffxk+vz0WjKsn0bAbb
	Zn3Od0mPIy15tsQZk7yLSo06+f6EPTzOpJg97E69tIBqHzc1ESS5x+iVebzJ5s+0v5KZhJccPyn
	UwT9ZQYzbRrfWOs7yt0Y3joF87Y9R6rWY35Fj75ylw0rYQiAQidHyTXuaoMho8DIEwOqFeXVkIG
	fF2Do38lyrjdYt6D85sYgeGw54N5JPxvyooDvZXyFqxMt7MgQguJlfJcBIsVpfhhoaaW+ehliEW
	hJgp7ZMaZM5rZw1/aYFuecpUg+huhj2vUy/M3BepGebEjxRzRlqJUa2UVjWTPlm7hMDIOrF+yC9
	bNvfi0uiMA3FjBxNC9j2SjN8mwISBCXbkAJ5wzVe2VMVXBlVkvh6GycNApPF9fhVpVZ9XQVYhDJ
	ZG9OOx3iJhiSUaWJjV9yRKbHtg5G2hPQnL6pY5K/xcHr/0sBtUm6wCyv5+u3pWpq9QOJIjiG5IX
	7nz6oFEib2sEbsw==
X-Received: by 2002:a05:7300:8188:b0:382:61d0:f375 with SMTP id 5a478bee46e88-3856e63b050mr17936494eec.7.1795435314904;
        Mon, 23 Nov 2026 04:01:54 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e99fdsm45141438eec.5.2026.11.23.04.01.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 04:01:54 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 18/27] Docs/admin-guide/mm/damon/usage: update for REPORT_MADE probe filter
Date: Mon, 23 Nov 2026 20:01:38 +0800
Message-ID: <20261123120144.9278-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-19-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-19-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 4ECE120013
X-Stat-Signature: be3o66pwkxubazdz5bxw96y4eyts716m
X-Rspam-User:
X-HE-Tag: 1795435316-754729
X-HE-Meta: U2FsdGVkX1/IpEEoqG7o8qhvoJp5YsYQeKh0+aB89HZg8tRvp1ov+ir8gpjRT316GUTOqeNIVZ+eAXyWkMoNKF4T9YqWgxJFfQyxSn7Xw1t1LvekUrukfliXOk26qDng9mz9yHMSwa+xV2JerQaBSq+yRoI6DgivXQKFVdb1qQnJdfMPO473p7HxKerR2BY4D5LN9LJI9HWOpjGMaNOzhTfxoMC86VnL7jausCBRY9vl88h64gwhQ1SjvN60lqW8Oqql2WiCUMY323hgXA6T+gjNv53/DIAWXOxSsSv7l5MY4dGBV1ZfXKaxv0ciUDK0auozd4bSC49E4IxbY3CJSZFOc6v3SRFa2qUYQcKJxxOywxAevuXoYTuAaPZk1+wyCYl4O0w4fyA1NkTAe/H4pGqP26YL7RR94o30AYhorqQIUz72PRjZvuR19qkuydzmJ0bLY+b0IJIjkN+atipry2TDPdo/uPVge5ObnOBj2pfsoUeYCSIUdWU4t0VM/XvBlAW3mWP9nbwu6uKRJNABRbcdR6e0qBelYO/023H7g6QrDOiEKxHH70+4fgH4PCAwwyXF9OMgokCYxw+ZBhpG+RHsxg/LeusHYR+oQyowRDfY2kgYkpLQARWgeWZk6pqd0p/6r+E3mN+/ZBvfxdjI8qsJCnntusvcEKCoMaEJAQWaC67wA6663e/1UmUY5Re5o27sXUI4sgUDe/DfoHg1OASfpIXnwGCEEpXPAPJJwbd9t+s8ZG+oRMB42ia0hD96pKKbzWE1ryZ8DkwEzmmytI/JQqT64SqknS283D8sgNV/Ek7nCmnZad2N0j8RGHGHM45xKsXlHbhdgjdxF2u4Oo9t7VxvZu2VT2se9nGL5lWD3WCvq8+VihCCAAAsZV8QqzYiIqIbP7ipz9hgQHijVql1ogkRchn4MK3JKDphKJzkFd4YtYyroxKTuyEcaGwsm/plSHxpUQtXKolA4Zr
 30txmdUa
 DGiGaDjE5PvEvuE3KFRcwSgrUDclIczbTwfXINQzEL2e67I3x+jv6Y/1XXChwt2nQ5aO4SMhJluMWa8pGk6VdaDu6HKI8dC7iH2wxEEutBKEgVqKbnmUR663LsJ9Pyzq6RIyS/uAu++gOuRJPHRRf+H+Cr83wqlvCKwfVuLjIYcvNI6/Oo43V7QHJCnLzTw0FP6y4RMFGaZr5axZcVAsMqATnLQhtt3WL8RvlHPW1D7f15PG/TllBsMSNxU0MP6ddDP6Txg7TsJ57YsGim1tBTNTM6gNgP3s/+IbWjl2S0xEmShRtnKiQwROBuiRiNU/TaAKdI7MV64gwWxQ/u4JH4clQWYfZ8gub6Sq0cump3uVG3IKxeRpnY69MQMh2obLbTwNZCt0RhCs0r4Echn71/twkxSYhoDFEmVSn5C4SN2Re5KO0x573IZYhwjIXgJEn7RDpUwq7a/ffOp6PJC6zNhYfNaMeJ8Vgr9ofnbcJMOMCStQLBYot6jeMUEMQFIgVZ4qTsZCuIbsy3MYpY6adq5TJUeJDdqDiur9/wlE62DU0+qpzm/bGMdca3Y84FvxwErOs9cTX4CLMFneww5CYTSeCPLDxi1JDwllcuW1iVKBLAxepxFn7NIWoF79i47LZSgbtPrRIB3Ac1xe4jNpoDQek6CxdNFwLBoi9qGIpFsusRrDk9DPlEdJ84i6MMWMiZa4qjn7CrXK29dpZI7gmoqHCSGGson1xTLQZ6JQkTp4LyoyB6m3P13q32qtYJ0lQVaqEcg86Lf6QzuR7yJFsJYWbO5m8EZmU0PY5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 13:00:02 -0800 SJ Park <sj@kernel.org> wrote:

> Update DAMON usage document for the newly added REPORT_MADE type probe
> filter support.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>


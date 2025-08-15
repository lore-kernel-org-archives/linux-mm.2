Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF1D5CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81EBA6B0092; Fri, 15 Aug 2025 13:39:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF0A6B009B; Fri, 15 Aug 2025 13:39:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6988C6B009D; Fri, 15 Aug 2025 13:39:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53E596B0092
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:39:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09AE71601E7
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:39:29 +0000 (UTC)
X-FDA: 83779703658.16.A91AF8F
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2807FC0014
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:39:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aksV3qHu;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755279567; a=rsa-sha256;
	cv=none;
	b=E27mY9ZWiJI6Hn2RxIsOcIuU5f5xFTre/DJEBkxxQ8mDTQZWAeqnANS9kaHHdLOCAM7kBZ
	adbU5eZn3SLITRqKWiqMQBoLwuF90tzC94hhK9Sz5/OjJzlmIzwC/uCSYZrvTdD2s8dcPR
	E8dyqL1q9z4WSB+2RiLMM87LKr5K/PU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aksV3qHu;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755279567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DzG0LZlHGH3bOOtZ8yuLvRlkiHDfO2BsTKY54JW4yq4=;
	b=ZadwiMhGuSaNOZIKhUd/dOw4hWdwfwSFOvJ0WBAGeQ+n3ATTYZnE+MyYEzIq+VpD8D32ns
	ZbSyab0NZcDlK+j1u7WoikZUrN+f8BTcw5CeKCSSEmdsvFZH6q3TZy7UyoBIKk26BifcbY
	iQ8WOhPLd7fSiMSq8TjTPBx0DTCGZXU=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45a1b05a59fso14415615e9.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755279565; x=1755884365; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DzG0LZlHGH3bOOtZ8yuLvRlkiHDfO2BsTKY54JW4yq4=;
        b=aksV3qHuKqmJxnLzvyHQdPEPqImw6FlzgMETbQJaFbUtnJhu7WCtEP0NSvBRDBPMkr
         7DKzkZTO7kHBEDjzoPiUQALxTSlevPhAsltia53Tb5TQFr74lwafwEPpagf0hxxbWQfc
         ZgkkxPHrtAhD8SiL/llI74idB9Gu5L97yvX1mvv7Yf0X2ZG5T/ev4KK4lm/QKic4igEr
         kLXhXc7wb0Ia8+/Acr+6qq/u1eoOoQYnVYRS0QETKWGD6gWLH08gYRnjpY+ABTOlxTJY
         d+8kEhh4FFfWUberngFYyxutPMaJqnM9P8oj4zQ//xj8pU/rvcxHfO+3SUDtcBRt/B3T
         tLtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755279565; x=1755884365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DzG0LZlHGH3bOOtZ8yuLvRlkiHDfO2BsTKY54JW4yq4=;
        b=PLzbW6w1Sp50RFYCEaRPr+xEocsIf5LTeuZH5Fl2kgRw29hcjKVfPBbyuVvjOPznl8
         l3HQuoqPS8g+gAAxCTqkxOge0gPfe28piKWBilFjG4LijbUZg1q+YA9Ics/YdhtA8bnx
         TBhuK1B8D3NpBgU8+Yv24O2+5sWbWTmzSdrUDMJumdYXpbftJPecq89161yp7ysGy3nr
         w61YHBQdId3ynx3fK4T3KB7zSHqPdMvORiV1Nm6paU+AY6zpGjrdVj/M+7iKF+pXezxv
         vrQjyv1YU4xDp4OLd8TE32flL4iwSdxOITQGIX6NB/C7pk0tiMABbJ42Vp1NaVhc4DDg
         tV+A==
X-Forwarded-Encrypted: i=1; AJvYcCXs4SucTIgF8IstZ0Uk+EH7FlvPjhO8j2XhfSQ8IOV8LcoFFxrWrpDZDm3SSfPBbB5VmxhT7EkvfA==@kvack.org
X-Gm-Message-State: AOJu0YxoTlsNM96Y+9OFqQ1k6FV9UKCEBn0JvpbZHwQD1oL0oX+3SkoA
	fXaUVZrk92Iu3s2THw36YOwjKQa4cmO4wsjwsvS9c4C0sIpQ50AUwo74ZZ4Z8D8KIs4=
X-Gm-Gg: ASbGncuYVLWHptgrhm97wfS/7727FOAsEuoBDiw9tdEPDNM5JyWg22fo8QZptPfYXNH
	7OvW4vWR6Jkpz9hYycff9RRsDmGVV6/PUQwhAsPk/OG89qFr4nKfxToZ8XHXMQgDlihXd/C/pe0
	S6HFUhVuA1f3kbOZIKaMmqpqgrQF8mYu9DHFcQE6q/aEK3jOvaXNpqeKuDAF8mTPMcWxYHzoNnp
	nTUwbQfTVMd2sUuvUa486/idj9R2yO5V2nuvinzIt/cS9nYqvc5UZNSBKyt8C2doQLn8fyKWnjh
	UBnlPQnXLWaPkbL1YMSMY8MKcR8Y782ddVcmrUwZQHS8tomTq/p1veAKO69+8QGjiRg+MLZDT6j
	MJy8BqdCithJw7gl1xcV+3Jg1+cSkVa7ULczdyWIK7w==
X-Google-Smtp-Source: AGHT+IEQtqoj7OJMpPUFnt1ji9bSa+u38yG5PGpHc7mF3c26ryzthKx7wFt40yjy8HfsIxTJ4Rr5hA==
X-Received: by 2002:a05:6000:2289:b0:3b8:d0bb:7541 with SMTP id ffacd0b85a97d-3bb68fdd5efmr2396919f8f.40.1755279565547;
        Fri, 15 Aug 2025 10:39:25 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-323311233cdsm4872522a91.21.2025.08.15.10.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 10:39:24 -0700 (PDT)
Date: Fri, 15 Aug 2025 19:39:06 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	Matthieu Baerts <matttbe@kernel.org>, Mat Martineau <martineau@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Mina Almasry <almasrymina@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 net-next 01/10] mptcp: Fix up subflow's memcg when
 CONFIG_SOCK_CGROUP_DATA=n.
Message-ID: <gmiwpzpgcnnzg2jjhonfcchkbv7zrzgbawvgfgfwrjmvvihqdc@gaq7bbe4ktwc>
References: <20250814200912.1040628-1-kuniyu@google.com>
 <20250814200912.1040628-2-kuniyu@google.com>
 <cs5uvm72eyzqljcxtmienkmmth54pqqjmlyya5vf3twncbp7u5@jfnktl43r5se>
 <CAAVpQUDyy9f7=LNZc2ka2RiOhR3_eOhEb+Nih37HnF0_cdrJqA@mail.gmail.com>
 <r3czpatkdegf7aoo3ezvrvzuqkixsb557okybueig4fcuknku3@jkgzexpt7dnq>
 <CAAVpQUAx9SyA96b_UYofbhM2TPgAGSqq_=-g6ERqmbCZP04-PA@mail.gmail.com>
 <kr6cv3njfdjzc2wcrixudszd2szzcso7ikpm6d5xsxe7rfppjs@5bvfwpelgj6f>
 <CAAVpQUCMcm8sKbNqW9o6Ov1MtC67Z--NTv9me1xcYgCkbJxK5g@mail.gmail.com>
 <CAAVpQUBO8TXjjtt++kF0R-qs-Utn-eY5o321NyAALEYTfq0xGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="y4wp3wkqhrel3mvn"
Content-Disposition: inline
In-Reply-To: <CAAVpQUBO8TXjjtt++kF0R-qs-Utn-eY5o321NyAALEYTfq0xGw@mail.gmail.com>
X-Rspamd-Queue-Id: 2807FC0014
X-Stat-Signature: ypxd61gw7inwwcqtqj11pnxt5aerwhtg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755279566-327567
X-HE-Meta: U2FsdGVkX19lhPt909Jfadv356MGmuv8KOTX4HA3dM/lzcW5Tpy6eAC/u/xJTRSG7rsfbv8P/uwazweLy4+pSp4ICiKC9ieM307nBjbv5FmYrtTe0UR3piXANxUUdCt4z8mLNmDE0KpR63Xu5XsjBF31tq04CfGJSxQAxqpbFtinqRA/w/KsLVT9nY3MCMMeqRE0w9HMB4DyCd2PEfQclgYA7Y8WOPVZbceIhH1Xfqey/lL4e5jycgu+KMhuTuQQ6KfMKtbsYsAULNEGX73hkJS+uBvUe+55eGxyerFtBWMB84bCzCuZCby+Rbc5wBPsyIxRkkphRUoMrGbFZhuL6a7u82gIF3IhjXWrpML6FqvdmwgswbPd5BjIAsEeg77AWn3n9KbN5a9nrsuzLkiBdCGKRUyAyGHBWL8GlN1ZoK5oVc0QNl4StW+iWhxcp6dV2HQobjBRY1A986r0Vp3C+zMgk+7KQ/ooyJlY+vZsDfykqLn88fFRvlKN4koD2i8G3070lIPL8uqzb0/FXJnKKgSDpRloUlvojFt9xl4+oMm+yBnz2aITrdx0zffDAxPj30JzfJpAxW710vApXjFzx2G2MsMdMCjA6cbRu1uRG2wu6mrwynXWzB1y86+bH/0+5INC/O6GU5TolxpEgLxTq8uMVhxEUG8NxlFJdsn5lqTvy/8yuY0X7z2v7or6xgkene68JfVvIYfCV4eiyQUlw0A+fpzHQnBeJwZJHoXxe+iaFqUOjy5CUO349HnLRtsGcHGjxAScS6s9tO7hyz4iwxmMlZMX8DN1F2hu8qhFnlKOlYFMJ66Rm4qvagFKD0KSwNzigy+MHQ1pN/IH+D2Xxg3Ws9ZmMI507vMeWgAs36LWMMqgm+JlzJZs48+sCqbM4SpFrwhF/hllk22CoDNFdCnfd1N501o+VKXOeU+9CMXIR1iyu3P47QquksW08Xa7XqGkS0Q8eD9V2EZZjhY
 laOLi/DD
 SMEDe651h0EwAt+dvCAQfBi4NYOrE/rq+ZNFyAZkmrxi6GUW/LNPSKsMXCf0d2e1qIM+tKtMbokzXRd3X/+SXeOU5feOFYG1UkfSQDnk9AP8/5MHMP7WtZALPSbHfzoVXOzVsUubLzj11RJyMGYgxL1JTbqcTUaYYrGowCPkG1Tivh4XYtlaQDXQ3KenUQKGz3KLG6TanZ3fw3e/YJfUelUxSa6LywdiT9er+l9YwMtb7DVjYSc3VxWVtQg3npu4BkuZSKiz/KF+uzEkpn83YTpwStATLUCFFNTcjIxHf08ijp+rjrHv/KVN9ifuEjkry7HVbKy5vk9WFWqIVAx6EM5CsxZ09NhjwVALLfJ7e3wEoT2++nAkNqmXa+Pua4Og8r0kyGSZV3DdCyvDPGbZBpzTN+g7064FwPp3yy7WUqQ9MVZw4/bzFbtpJDgMG+VCUdw+Hq7UMYTjPMJHmF1g5GISTrledft/NB8c297L9jdYLndzEj3HTOeU14MTYMaXrmOs1eaU7ebBl4VsGguwAn09X1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--y4wp3wkqhrel3mvn
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH v4 net-next 01/10] mptcp: Fix up subflow's memcg when
 CONFIG_SOCK_CGROUP_DATA=n.
MIME-Version: 1.0

On Fri, Aug 15, 2025 at 10:24:12AM -0700, Kuniyuki Iwashima <kuniyu@google.com> wrote:
> and we need to manually copy the memcg anyway..

(Is that in a later patch?)

But fair enough :-/


Michal

--y4wp3wkqhrel3mvn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaJ9wuAAKCRB+PQLnlNv4
CH4YAQC8zojrNNQgYpmFJQUBnZHfg4T+IF01Rw6OCepycZuaVgD8Cfgdr1bVXJly
2vehjqtlGG8wN1oo3l6EVENniEd0yAo=
=/lQI
-----END PGP SIGNATURE-----

--y4wp3wkqhrel3mvn--


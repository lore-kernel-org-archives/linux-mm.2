Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E6D606B833
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=NI3Q+L9F
Received: by kanga.kvack.org (Postfix)
	id 22B916B05B5; Wed, 11 Nov 2026 14:26:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DCC96B05B6; Wed, 11 Nov 2026 14:26:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A42E6B05B7; Wed, 11 Nov 2026 14:26:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6DF26B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:26:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39E9F1C261E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:26:32 +0000 (UTC)
X-FDA: 85423819824.19.E03079F
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 135821A0002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:26:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=NI3Q+L9F;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794425190;
	b=6W7Xaw99THGTUC8C9gASQd5nDFcoetGIxsGHZrSQCY6N3UAZNlNwvl8B8C32Lll7Qj2r4B
	kLDAOqwZKIbX1gnE7Iery2fRG1gDYYxsK3wVR5A6Lm8FJsIrqDSPAAZMKGT7EyJUibhdj4
	k4QcPzIVaS2+kZCQdMRhboRIQNMLSps=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794425190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wd2WluVLwj4r2VIyBQDufDpYxaAOyEu9BCBLHFr84dA=;
	b=GtpqVBLBz63JXUeDCLrGWUkanQy9jt1GZcKqevWnXjy/bwXsno4Zcz7+WcMixHUCljktDj
	f+wqkvACJhZg6LOyWwFLW9eHIA17gAOadMLAFmZ2RDTf+o2vwIq3zSpiFXdi24hgwGg+Rc
	l8uR6dui4Ten3yn++q17D/rozAOSU10=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=NI3Q+L9F;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c506a231b88so122158766b.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794425189; x=1795029989; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wd2WluVLwj4r2VIyBQDufDpYxaAOyEu9BCBLHFr84dA=;
        b=NI3Q+L9FWmCNH3JjFtt06jp4Dh1qFT5lP0HXwEkXr+gnsAn6TlFGQvbS3ENqTpYsmg
         cUwmN6PcEW0SYdFsnroGYVBrQ+4tKD7Jj+rNYGh4gVmsEAg7vz7rNu8JEAJPtrWcL0QP
         HKm3YiP7N81E7pxzHjxcx6VRUzgQeBN6ZdnEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794425189; x=1795029989;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wd2WluVLwj4r2VIyBQDufDpYxaAOyEu9BCBLHFr84dA=;
        b=Ni/Gz62RMvABX277YSan655ykw/V8TJAfXgx7M04cyj5k9BxV/G93QEs5y4R1sn4U1
         1eptF/srVcrzs62dtcnF//h4507esajPy8v0EFONVwkQp+tccnmy13PiqTeHftyAKTTN
         4RGnrK9fWmxFiLCHkr23tHdSs08Dpq57UWMv+9HVygtXAI/HlaPdOWKcBgP+UWEMC9zw
         JURqhPk0KQWl5FKtM9+U4/OhKpOWK6LWa2Rs+q5x8dghu4qkTckqghFooJh7dNV403Uv
         H8qsLQOE9z0QCdfw/KQOWRL4r5P0uSHhd8fH0QMp+oJ+m4UTwBZYkY+lb/3iAie3Vawm
         svjA==
X-Forwarded-Encrypted: i=1; AL+hErG1ev3/uoNVDfEl/3inXmaHHGYKwI77ONJzrb8PjllQhAi6AwjLOaZg4XuGb7XkHi4qZBfYjw3cdg==@kvack.org
X-Gm-Message-State: APuU4Z97mMpF1V+jf7WXmo0fu8miotODQUZXw8s7FA+G0qVAZYl4J1SG
	ZxnXwPe11HiPaypkVvxdFXK9X/0ZGI+7Cal09XLZbECnCLoBjoRpwt9suf77VUHbulLM+jpA/m9
	Udx3mSGA=
X-Gm-Gg: AYBFou2tDZB1+nuf349+ROg5kPPY26nxrgqsYBHiVhi+ugGemhddTZP91dSjnaPj8J5
	aS5Zv/mKBK+yXMGHfQl6fFcXS0CBWtko2wMCYNAsIHs39j7KU51abZLCf1kgAfKETgJxF8MuiQL
	iWkyMKqAYq0ScNVHsIo171oZEON2nN+JNogmG6lIhRmbur5FiNeAE2Iw9n3CvnpF4Ypufx7U51m
	LAYJaxllcTDCbzvjBcIcSNKdkrr1ck/CBqpxaAExigQlj88446Vx6I7y9+mnGHikv3be2v6W52L
	ouxc9urI44iKMQxZFkYjIImpVR30WNjai+rupfEgHOgh5jKTy6ih1DIMNBNEgD2S0gx6NHdonTM
	SUlLYTa4PyaSpfi3c5Yz8s/B1VcqD9YZrTcwCiYRlR/H0DQvMsURugAc6fF+bl9B5OMJ0lfQhUs
	uEXcPBlxI374Jxk6gyO4ZsEFHATWNvMnif0j1iOisMw0M+2J7m88n8ebE+5afIyV4eHQ/YfZRwI
	AO+QbzDPJ9MblqvpCo24HBAxhy7mB+QCmkLAe9N/ISRixOwZcu50D6/vBqxmgwSOycuy6I6Ipc/
	mlTsW/Jt2HxiiLflpNI73+G7eM2xaLORUv8HTHfVZCQ/df9luUddHi+StKPXVDuo5Qq44HPEvYN
	6Vp0=
X-Received: by 2002:a17:907:f815:b0:c49:cfcd:69e5 with SMTP id a640c23a62f3a-c5066c8ed5amr280925766b.32.1794425188527;
        Wed, 11 Nov 2026 11:26:28 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a693e82sm261483766b.83.2026.11.11.11.26.26
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 11:26:27 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b7221c0f2cso3186488a12.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:26:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErE6uIL6lSjHb0zzvFzUPILzxIRVLcIxfiJNbKU6MJ3h4z49TgcfGlkZ3IDo2hR1z0eOTpO5OhGchw==@kvack.org
X-Received: by 2002:aa7:d1ca:0:b0:6b5:6478:a9a5 with SMTP id
 4fb4d7f45d1cf-6b7773edf34mr1838418a12.10.1794425186528; Wed, 11 Nov 2026
 11:26:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110145241.536019-1-kas@kernel.org> <20261110145241.536019-2-kas@kernel.org>
 <avNuQqLf9CG9dSsE@casper.infradead.org> <20261111-heimreisen-ungeziefer-empfunden-a892571f2c07@brauner>
 <20261111-thunfisch-wirbt-waldrand-822275b2d3b1@brauner> <CAHk-=wjPY=kfgnmtx4COEQjD5UzKx9m2-=KLGAZP4d=RKEH+pg@mail.gmail.com>
 <20261111-stumpf-montag-miterleben-c4e2feac8090@brauner>
In-Reply-To: <20261111-stumpf-montag-miterleben-c4e2feac8090@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Nov 2026 11:26:09 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjGXBnme-N+HvbzHH40ftb7Suc=kZVT5cuintQWyMHJ7Q@mail.gmail.com>
X-Gm-Features: AclHuK8LZq7-9ajWCZDJwTRjmLDnovqaiY30E_XKr8U-iLvj6BsIi-SShy4XPgk
Message-ID: <CAHk-=wjGXBnme-N+HvbzHH40ftb7Suc=kZVT5cuintQWyMHJ7Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
To: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Amit Shah <amit@kernel.org>, 
	Jan Kara <jack@suse.cz>, "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Bernd Schubert <bschubert@ddn.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 135821A0002
X-Rspamd-Server: rspam12
X-Stat-Signature: gaor985cc9tfmb8oqcpaumiwjtyokck6
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794425189-512117
X-HE-Meta: U2FsdGVkX1/7XuatN/k7/BZ60RKNmf9b9/F4+ty7PQNRQtVWGY7g4jf6Q6/UwnelLh6vBBRmErVL3xogBRTwcHwEPIQJxtCAx4vuUnxLl2x9j001uHEixWKkSOKUPobb2Usu+oLOxTpz7vQCJKDl+3vSie8ItoWzH/uFJW3FwqMfoo5SzIsXnfqG5QJtarFwLuCUubbfo7SG/2Wl3ZwJGkIr6jwQcy11a+ydTzg6U0F3OUrE/Jv3rOrKkPbPiFAA549BCDNFSh2pC1kTzLJ+qx+gP4VcD5souzacaMTmCMZaiil74mIWSGPjCsa3zB541lAQTcSmrzvRKiEwxPavN1HoxA9KnJ9/lfWBcOEHq9mtQSapl+OiTvpqLKMbitsgl+bgLC36Lw8FTsELShgUjuFsErkaEDz2PLNZWbw3GUMjPtzKxYIz4mRCrww7MwIDjIaZLRde9bcT8Hnmpot1Ianw9KXqNABBVZuebEeZ6ljK5V6UTNLv4LWjul+OAR5B6UMacGCq/z7d51hL77asjijlKkxLsgDJpUFtf0r4RHa2poOU5HJyY0DQEoijt2R/qiqufTYbfXq5MS13ns64dgKNzV98gStURrFPDlDlmy60QaiySAsDxcpk+7UZvy2000HmuxI3CM8QYl5a+s908ZSWjbry6BWXFcApn3uK3+eWoKTNN85mTRMwEMLedogF0+QdD99bpNk47xgPgk5M7CA6sb2whXcg90PfskiUkOoU7J7TEb/h+isHcNG+/DwzUzqLsSFhNs668I5v2NIVfnfkVwNKkLy82xNdO9OA6w5WgPnpqCFGYUUc57LqQLoJSb/QFm5UAxVd7JILboD28Whbckm1tQ4sfiJo7toRWU1zFMogyRUQhxbTxJuSxWSR9E7zN3teNX1c7uPQpP9xgexV8P5ie8G386cuoSALp+gpQpyi+JUC7JTwUmVsEYJOXoQdUCzlvrvFRHEDXZN
 iwNiEVUx
 sZ/3sjR6+2JKEeMepV55txAhEuFuU5ygMl99j0KwAXBMtrfbAaZJvuoO4avFtsgV/26kqVOOTOAgW/vbJPi82ih3m+9oLU6NZPLBk1qmV6BTFCPhnOgydxFIx5AMQszGt6NHzEMzRsDKUqo1MT25KL7v8GfTUAtbzi85tZOBJWvQXcTA94sefa/qA3FbD9DUtQQefUqUXingxTmuLq9AMShY87eb2mR5txIAmbFNyQmWliRGZkU4OBgNqeje0R/rssJjhiTWsxFADJBXebcW3yja1LzgvfKDLRkxV919VkiysN5o+w2WIRKSsbhh/1rtP1Jbnhyjl8XkHVnDaMVOR/UYvzjmBhdTc8yGiIzMJcN/DuOB4+4nrRq+n9pI6B+vGwOesyehqf+TztFeG3/e49FQNpHR7uxx0rqkwzQAjry9D8MV0evOJkIBkM2GWaDfVmA7kQRnsaSBSEy2Fpo7BtvZ8YpYabTgNTXomF2I6zfIfCNn2+zVk2tUtkVEFcmqxHkAMU1wwA576q7VWlOXeWqT4zLa10tcyw06Cw5+cMJiMJEWKpKg1CBt1NTvuklqDNpMB6nFZLH7M/DzU88UfsZ6nxQjJbAGbBJ46dqgoETeywNKMtdUQowC3ocIbu+cePoz5AuHPJZAu/+YBYggUsd0cAGsJUNt3kdq1d6gAO8etSlYDmllayAMhTabUz8lyiKal7+gsfWRIPv8E2bzpOZfv9xgZkP7JWromluCSFoeiP4JJGAUgbkHisK8koHFhnodD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 at 10:53, Christian Brauner <brauner@kernel.org> wrote:
>
> If that's the official new stance than I'm very happy.

I definitely want to remove HIGHMEM entirely in the not too distant
future. And before we remove it, we can most definitely document the
fact that we will not be worried about insane users.

And things like security issues count as "insane user": if you use
HIGHMEM outside of controlled embedded setups or museum pieces you get
to keep both pieces when it breaks.

IOW, it's legacy. We should aim to not introduce *new* bugs to it, but
if there are pre-existing bugs they very much count as "don't care",
this will be removed soon.

I think the only reason it wasn't removed a couple of years ago
already is basically a few old 32-bit ARM platforms that still used
it.

Those platforms still exist, and I predict that they'll still exist
next year, but if those users have to stay at the current LTS kernel,
that's fine.

                  Linus


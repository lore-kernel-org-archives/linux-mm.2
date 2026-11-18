Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C64606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=he7jUpP7
Received: by kanga.kvack.org (Postfix)
	id 7B93B6B0608; Wed, 18 Nov 2026 17:36:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769EF6B0609; Wed, 18 Nov 2026 17:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60AFC6B060A; Wed, 18 Nov 2026 17:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC936B0608
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:36:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A82E1C432E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:36:34 +0000 (UTC)
X-FDA: 85449700308.05.F44A128
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A6937C0008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:36:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=he7jUpP7;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041392;
	b=bKh1rnV989WuVSmJyFSTrdlC0tldNmhUotoXQRAjV2fhiOo/o5yDUkUnT+yaM6F+KFy400
	HjVfbeH+H9rAlzpe0oyFbFWXXYt8dxIHOHlVAj43FX5NP4b2X/IODjmfFBrDPqxvbkNmR9
	M6i/j8swoqYdmLDOLPG7DOEq0O4rZrY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=giz9sJbi7AOf6PAf+EITaeI2qW09MerlLLpsHbUYRWE=;
	b=qiGvUjHYvd9+4/JFOjXHTesHPkxw/1BLzZo/gnvgJ6A2+Yq3qIeOP/WuMf+/xhT5pw/cjF
	4/2ahybxu7CW9aCd35CWia2kUusR8Jjil1A4r/3gGeiDJHPVdLLQMOJc0yWHS+QX7BYKUg
	NUTGHn2lVpRkzQBqySYBNvuj/vunC+g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=he7jUpP7;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28D8D466E2;
	Wed, 18 Nov 2026 22:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702831F000C5;
	Wed, 18 Nov 2026 22:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795041391;
	bh=giz9sJbi7AOf6PAf+EITaeI2qW09MerlLLpsHbUYRWE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=he7jUpP7W8wDKQl/Ac9/kNQcvc3DMO1YkGS7w+fX+gzQALPIfhbbsoZRzonAL29hz
	 XV2HJ4mGcFOxPoxIyvK2iqLjsLfC80ujakgr3GD3gBIexhQZbwv1Ra29Nv6i0urF93
	 mFVUHruiJeluzhgNRXnqLSsr9Wx9o3USwccENA1lM4ilNwGvubCTIWITLl6XcGO0fS
	 RI44swSjupHrKUIAq31VGqsT4SEO7dYtfDCAzwOIPxgIj9xsJNpjbB91y/6otnFA5T
	 NH9Sr0EiJ/BBY4/r0MRuie9RbCf5YhUSLt8DUfj+85e1AqQRk2cYYKFqlKIf8QkfNX
	 rTYiX1mfpLPxA==
Message-ID: <9bc43f9b-d721-408c-bf78-0f08f6ec4bb2@kernel.org>
Date: Wed, 18 Nov 2026 23:36:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 00/13] Namespace for namespace roots
Content-Language: en-US
To: Jarkko Sakkinen <jarkko@kernel.org>, David Howells <dhowells@redhat.com>
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@amacapital.net>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Ben Segall <bsegall@google.com>, Christian Brauner <brauner@kernel.org>,
 David Hildenbrand <david@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Jan Kara <jack@suse.cz>, John Johansen <john.johansen@canonical.com>,
 Jonathan Corbet <corbet@lwn.net>, Juri Lelli <juri.lelli@redhat.com>,
 Kees Cook <kees@kernel.org>, K Prateek Nayak <kprateek.nayak@amd.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Manfred Spraul <manfred@colorfullife.com>, Mel Gorman <mgorman@suse.de>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
 Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdunlap@infradead.org>,
 Serge Hallyn <sergeh@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Valentin Schneider <vschneid@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
References: <20261118193539.240065-1-jarkko@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6937C0008
X-Rspam-User:
X-Stat-Signature: p7o9n9dm8hz8i8xzqhk4c1nx8fpixffi
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795041392-477502
X-HE-Meta: U2FsdGVkX18HLXyLi8pG2/E4II6jUOqGO+rn1SkX7k92gy1HoJ7YnBlJVP9O4eetFrkNLnJeDnSlNbbcmRc5CTCbK6hvlePBeII3dcjljjiRaukHb4Q2r5FF9JGFKaIxBB1Y3FzFm1p+wLmg0QM6vieL4fLzYhP9jRI6mI4YmmgkArjeB0vb1pRDD9fH9hyMvDz9jzi11ekKDhF7fmDTUkX7xVm2FJf8hcpXLOvXmx2vG+LGWFdEL0ORMNHy4Rs/MJMUDyLbWyJDq+p8tJx3iJ4kFxIcSIQFG80TFcqBw+uwYn6Voo/ph+xfLCW9kzjsRAxzy4P90GfcPaB3gbOAceaF91bthq4XnZXI4iB3ckqCsEWnm8+VaYNq+ZKeMqd3FqkxxDCMaAevQMyl4oBAktu8Aql3jub9ZEWbUkXg2ICs1IT8YFSfnbzfHyuS32rgbRByyY96ef0RN/ZY0PgU79YFfV7y4U2fGnTGvpRnZ6kwdL54ZTT4rJ2wEkcpr2NHxWibPDGVSj2ihiFIVPKMqr4VZrxsKify6ML0aTGoEBXbUISyGW2AuquDyMd/2armdfm0vmCkNUJidGKNsKBTOqmZK256GjVXy5RsU4CyvUpnOWOJRP4JGTB72DGjnshOG6rogiZ0ISN0bw5oanO1FZluToAD1+v4yCqxVcRV01KH6nK1iPpkvEpToiwMVSxZaKG64myA6ilq3rmjooWAKqsnxpJ5ZTL7oPwH3zashoDG/3JdCo+8SbiFtZ/wD91b6G6r8Y13hq6x1zcBu51qgH+EhVjQZio8Baw9xl7XoyzlLqP5Ui+t0GMVYd9QsTDtfwM4+J+oV6vs/pDzcnbOVPweWJTwv/TW8KZTYKoDCWGoTAdtxcUPYvxUx8qmtc8Dx4Q7uSDTjZdeeHfQhtViQQeSniC8A5HkuknaUdWWJ9sB8Ls2M5RebKs6/qTTtLdnr9AgXfnfVA/IwiSXq2B
 CV/YLdeI
 np4K4xdIZQ8j9Aprf5rBMiiQxw6DTiLXW1QJiFI8R6j8G0tNlRSocMz9NQ96gBWCAfGer+ZRtQT1WRfjUMdg5MgJRqJTvveymLNMTkEFPo+S7SzkhfQhxf4E54zjFyAVGnVuKYo7+gtl9w6+GT+dpsd7HSSzfy8WqVLpYzajj1x+eipYgX9Si3YP68i0vZ54QXaKq1eR3El/ZFTko4ZyNtaWzA/BvFGj4Gpe/kJhohiMpYl+GzF0loffFOIP/SY0kfronUdvr5VyYU7+81gBQAtummliy7LmJndWJk6yBb8Ua4+Q/IrITigSSb+CTN+9cN9cN9qjhgXzH8pMWtDsD4tb0GbryewwzKW7gNHTUWqR6e+7rkdwCaHx5rVaDOYXE/NLdcYuo5deavBIi3+NUMA4ksNE0rZHT7blXPF7JoNRdgLTakbr+ZhVFFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 20:35, Jarkko Sakkinen wrote:
> VERSIONS
> ========
> 
> v2: https://lore.kernel.org/linux-fsdevel/20261117231352.3816603-1-jarkko@kernel.org/
> v1: https://lore.kernel.org/linux-fsdevel/20261117050841.3289652-1-jarkko@kernel.org/

3 versions in 2 days, with 13 patches and such a vast CC list? Maybe slow
down a bit, please?



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74785F30948
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E53C6B0092; Thu,  5 Mar 2026 06:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F726B0093; Thu,  5 Mar 2026 06:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867E46B0095; Thu,  5 Mar 2026 06:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7923B6B0092
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:41:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13A118C732
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:41:03 +0000 (UTC)
X-FDA: 84511818006.20.2F52BAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3033FA000E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:41:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eh822lyb;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772710861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4POPT0yG693U4gpD2KNyc6X9P778pD0Xv7M6tfZl0Q=;
	b=cgnBmZ0mX0kMr/bGwR+GUq4RtcVhBlrwnMXkRf86HR+5SGXCZEPiz2YlR7DDcss0Q1GnkQ
	mxycWlhVXZuotcGMmyiXry+kIEOwOrfz/TxI3BhBYfCBQOva+eMGPQ0HjGZNduSCDnZ2Mp
	j6SEdA6OavIuFb0miNnlyMfM/qh1i0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772710861; a=rsa-sha256;
	cv=none;
	b=8TKKmlYj3fp8+HmlW1TGt4Hp7bJgr7i5cXVc9buDTAWZM9PPkqHI6CfF+C0mxI3OHijY3G
	f2LDdc4K7kra8k6vDJKljbi6WKbnN2ViQFV396RhSDTTXOknh0WXsNVVatjn5Qol4SJMsk
	VzIESMtVdv2bqpFh65MgEoc65KLuN8k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eh822lyb;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 255CE40D88;
	Thu,  5 Mar 2026 11:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB38C116C6;
	Thu,  5 Mar 2026 11:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772710860;
	bh=ruHhWrDTVyY6omBzybvhVg3FC0p+SsmHeEkllUy+ELw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eh822lybAXjox2yIdvaS51CpRIgXuAOfbYYWlIeK6+vUE8MCIewdrLkMFVSaPc3Bs
	 iT/gNJfIXB6hK/6T1zZ6efYa5bJ6f8Tkv10s26Gc9+PMrt4vWf6WcnOuEvryaEIYNX
	 rjS9LquJq8R3ZBubHuwJrvn4dFy9mM+E8gzLSIsUM816U1VHAd86mY2VIaXIsvAg2d
	 ixqfbT73Rt1vZaL+m9/fwGrahDDflJ2sl0EcNFvXUAxPwY9zEIV70dQtF+w5tj91n8
	 haE2ZjTn3XhLns6WanC1giGFT6BYhgtcTlSWmRyRHYNQLTWdSrRC3bCYN2LMyncOXP
	 zJmalntBAQX7Q==
Message-ID: <5f4d8780-55f1-4b60-840a-056da7401848@kernel.org>
Date: Thu, 5 Mar 2026 12:40:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: Tytus Rogalewski <tytanick@gmail.com>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
 Jens Axboe <axboe@kernel.dk>
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org>
 <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
 <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
 <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org>
 <CANfXJzto6Ewoj2qDQ5OJEMAuxVcfFcvuxbtKChentqvb2r+jGQ@mail.gmail.com>
 <e2ce4df6-ef2e-4a0c-aee4-86d9614017cc@kernel.org>
 <CANfXJzt7yGZZcuBjmazU9n7V8vupMSLNm+qCiZxcrmtUZicR1g@mail.gmail.com>
 <CANfXJzthDnrQJoCQWrfZwK1Mrw4QZv92ZEzsOy6WGqq3zCYzHw@mail.gmail.com>
 <0dfd588c-3284-4310-b1cd-aab54567f0c0@kernel.org>
 <CANfXJzs29Zv7Qw7cAiEzDLdTJpQEbm6mPeLTpuZkErV5GsDKfQ@mail.gmail.com>
 <ed3eecfa-a8d7-46fc-bbcd-025fd73e5511@kernel.org>
 <CANfXJzsh9m1xHszB3vdSUxfOHpxV6zNDs_0DU=kjjFJ6szEpJg@mail.gmail.com>
 <05a26f9d-e7eb-4aa4-b5a3-d485945f81c6@kernel.org>
 <CANfXJztyrv3Bc-YtTWX64+tEWNGQE3cOdjs6PkAvR-aGYta-ng@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CANfXJztyrv3Bc-YtTWX64+tEWNGQE3cOdjs6PkAvR-aGYta-ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 848re19ri5qrpdumfbd915h9i7x8thrn
X-Rspamd-Queue-Id: 3033FA000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1772710860-917468
X-HE-Meta: U2FsdGVkX1+Z2fElRPqtZveuSJY3ene97WbVTLS/HlOVHxvfaL7pkIyhKkmjwbP7tJwcegITfXtScfpt5Cck6HlIH/LIHnzzHob0flo8K6mkfLfQp3ckwb7+DmNVerXdlwHuY3CjKri57zC/abQzu0w1ZBljNd8aS0niWIemJDnAYJ3sxap0ZZdqT1ucYfw5ax0l1nGWrwCc8s6U06Stua+mblfR7iJBLAELzfnS7tdD+BraP1SVzqUhEsO4psDoo9K1XsskaLSxgoI2ZTX3YpoN2UBnKxk6Ocdi1Q/PC8vEFj8Z5aRlPbxcLlR+9gFZ/B6XFLfSkDF1jiWC98A819rdoyYcQPi/HLfUU3nQVS0dkH1KOtFso/COHhTV5aYfTNAWI9bpcZpeAN73j0kf8WRruZ/KnVRhjJy8mnJEPVFIS7Ufd+Ig6gz+1fcrxC/Z4MiTK5jA8xvpBrOmyIg7FMtz5xnxdRrz9M4IwHgpv6xi248Xl0HEZgVLZFB3QbdWEF86DAWnjuBCCyc9TZPqnxO+SRixrUSKKlc59LVfR+RcDYZnpbGA1BD9Z8aVNfP2KQZHawk9uivgpqiq3R1M9ksDta0qU+nLo/bKcpv/R7A7Ed9tTyxlc6x8+g9MUumbsYU+/3WSVuMfF/8rKXUjDcIEE5UMZZ+/jF9Tormo4N83HbE8mO8mJXw+YgQ0Jlpea8sfDirn4TXBKGTKh3gfWy4/ycOZboBitOnDy+C95y5wl/MjSvCM24UVAjYzx6yN85zWLCQDokO9AZXHzNjS56In9L1Tz+kNz3n/uJJLbg4isfxqQhQp/yXufWoU1f6/IMhv3DrNXiwIRWsvcedvgavoB52y3pJ+RqSla3nN33Ri2a0bw5gjSO+aXeGcnKTAZ7C6FrOMKE+FQAe1UhGXBS2nPd0MGo/TkFq+SGM+5GMsd8WCCXOuBYVfmgI9f5mffhUh6/eJ/7YFnDlysmO
 wPcXKsVe
 cRwVUgr2nASZd+mHi/y+EqEr8wYsqQz1rXSzwjrUlM00lD6ojOhAOxyGVbFU2NsVL8QNL50R6YdvyztEYxxIx4QIGvj7O5Q/0BfjHbzKsYbj77BwD+sFgHv2YfPC4En6U8dqNlgrkiBa5VxIQFtKru3si1AvMR1rSvN9M4IXKdyBwMU17YzupF4t3w+16qdnfUCPE5pTW1AeYyFHmKaUGKKIdp3lWa2Gi9O3PU/VZ2aFkOWfUlkeZGC5w5cKlEpRqKcVSbtWUjlUnCXCGAzfZ+GCuvvvWABkm2YlIM47xrjc9h0cgEA5veKBlsQ9BNLfGEjMOI26C6fmQobo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 12:39, Tytus Rogalewski wrote:
> I had this problem on 6.19-rc4 yes. I saw it. But i cant reproduce it
> NOW - this is what i ment  :)

Ah, thanks for clarifying, makes sense!

-- 
Cheers,

David


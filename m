Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E48606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ARO/ajo2
Received: by kanga.kvack.org (Postfix)
	id 6F0A66B0474; Tue, 20 Oct 2026 06:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2BC6B0476; Tue, 20 Oct 2026 06:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B67D6B0477; Tue, 20 Oct 2026 06:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 327496B0474
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:20:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3DC9160110
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:20:35 +0000 (UTC)
X-FDA: 85342610430.20.CC71056
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0C2A912000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:20:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ARO/ajo2";
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792491634;
	b=dogC4K0tbTXKZJciZm2qZqxJlrhEpO4r6r+EMRyjM6h3aAZQAzM+HnbGrPU3z/evjwI85C
	3bV2qjpiVeq1WgK18R0baOE1x2xO/AIppsdtMwGaEyKT2hJQ048P/jZQx2/bwry1EeD2kO
	Kp6oqDLn+91lRMsf6k1f3KqzUOMtcCY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ARO/ajo2";
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792491634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLyz9JhGDWxy9NbjsVWTRULOrIKXHGlt/Z6IB5TxlIQ=;
	b=oSIOGfXke0qWl0KW8iW/BZV5Rfs/ttoFr8BgBasTXOP2Ca7FcNL2S9QzqjIxvboghAGak9
	wYbSe3yuHF5e7MPNcdE9RUFuW1DcIYIFa7g7n7MH6n9YIamwOu0xa+4wFmPW6enkG4vnwP
	Evk35eqbtXdHZ1y2RBOrj8ZXOmXbUKw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF639605ED;
	Tue, 20 Oct 2026 10:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEC51F000C4;
	Tue, 20 Oct 2026 10:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792491632;
	bh=nLyz9JhGDWxy9NbjsVWTRULOrIKXHGlt/Z6IB5TxlIQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ARO/ajo2zgnbhFh5hCsGaz2xlsiTq5MKQA6QPpY92hDVzgorsIZh6oB+ih4SUR7Sz
	 tIwJgdtYXc3kdAtc8zIZB1sQAhih9AFMDP5WLOrHIyxgNB/ReCHVUJyJqFnTHEjBqd
	 84SBrjEEA3ccXcwJHCAHI0pCb64e09QbkB+WwlUSIAJSRYofca91MsD2O5S/01RU8s
	 Kb2wYkAbksfdst2H+OBT2H1jGVQ5oyRchc/cWEuy3ecycbLOpz6QFvwMcn0KG8joWJ
	 0iBmrCBKxSd91sy0cvV/QL47OD2pi12m2LMfPXiVyiX3Kx6I6KP2r2/i6sSNyHy01m
	 jKAi1djIrLRrA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: tarunsahu@google.com,  linux-kselftest@vger.kernel.org,
  rppt@kernel.org,  shuah@kernel.org,  akpm@linux-foundation.org,
  linux-mm@kvack.org,  vipinsh@google.com,  linux-kernel@vger.kernel.org,
  dmatlack@google.com,  kexec@lists.infradead.org,  pratyush@kernel.org,
  graf@amazon.com
Subject: Re: [PATCH v1 3/7] liveupdate: Pass user argument to file preserve
 and retrieve
In-Reply-To: <CA+CK2bD83qVv54_Wps4GRr9otg32pW2A01WVTo-gTR=oYs95Vw@mail.gmail.com>
	(Pasha Tatashin's message of "Mon, 19 Oct 2026 15:31:50 -0400")
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
	<20261015093816.2438942-4-pasha.tatashin@soleen.com>
	<9huzwlrdh4q4.fsf@tarunix.c.googlers.com>
	<CA+CK2bD83qVv54_Wps4GRr9otg32pW2A01WVTo-gTR=oYs95Vw@mail.gmail.com>
Date: Tue, 20 Oct 2026 12:20:28 +0200
Message-ID: <2vxzfqy0hdw3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6udcfyuke6qj6uerdm5wjdcafoxudxup
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0C2A912000B
X-Rspam-User: 
X-HE-Tag: 1792491633-58289
X-HE-Meta: U2FsdGVkX1+LJ3k3kouYxpL2h445/U54Kha/bwCJjX2cqy96l4YvGEWM5mA6bKcnjugiCI7rT8lemU0E8BNlvuEE7aeawCf/s4BLYvrfslqLyLfExaujMcq7vQswrx2DVDe/UtR6cjkiMzjibgC1VvQYlGGA3P8hMHsBoxh4+aIKfb/ZK6RCBAgFSUQ9E5HqNaN3H/NT9GbcdDk+bwq/chEt0jIW6Fl+0TZGZbZdKayJXSe5dAcHFkarLvGsZVPDPQaX/rDXTckQmmc36rpXVOKiDx+FNTa6IF3Mb3kGesbNoPUmUnFrBux19c8ve+dzbEkINBXhuZOlHWdIhZ8iue5oHu7rNRKB9mNvu2ZjCvVyL0mE/PJ5AiOf2cckPrreei1EwBOWZvXg8bILxTMtTfKwpthZdAPTjMhW4bMa7iGqQQaBd72NCHUHuWShxm5sFSyldf3KsoA6SSH5f7vPezQ+ZGObZH66hiNQCIWBel/Jdi/yfsRu1Hll3LscRYrrjUwYufIaQspm376yjEeMS6IuYc1DAsY6z4JkPPXG56+2oP1wTM0fU9AzRkBCUziu4pzqDnwr4sh+CE+CLGOuDEWe/bGXF8MrlevJUghefoqDhvPCufNZSDqdSYAIDu/+bYGEeEHwXr50r/byh1yGzwrayFtrhqSYtvpnT7/6VONel954x2lWiP4U9qAuNtodV4YZGGaiGLdjx7cOzR6lyZ7YcXhWk74uXDZeU9G/EcKmpIDa+9oh2bTj/lGsCRrAKEAITrds3A5Gwdh+JEv586V3fBlXZjhIx3QoHBOSbjDeqfR+JHhEMpB0KE/D5b9Cnvm+eZWtNqjIvJiBE3PF3aY/K24/f5lQi8lgC0mwLr0d9LG/hJy7NCJ98ts9KqNEUNZhAuECybnfXmFT3WUVIuSDUXnRkQUiWrJgEZVC8/Nf2nf/Gb1Am5xqKLNT8ZlfbtoeTM2gbMJRLQvvCaS
 WkPj8Lzu
 VEgbyvauH0zKBskzAj2gKROU8vTcRLA8gEGJNxkoUUD2ryoJllp9F0qZMwQceor/FIfWGj4qSQLWcLDdhbxcU/6iKUh9grPs2m8kQaQaXa+LZlO7QV49qis/PIu+EpA3e4WMZcuzgCM8wfdDzYj0NFUurB84ZYMqzcoaLRAigzX3mWKwObQ02Rr8GzKSms262rnE28fvOnPZ7MN9sdRe6lQ8X/59HLe3amsSCcujA2Xw6I6zVHPT2N76W9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19 2026, Pasha Tatashin wrote:

> On Mon, Oct 19, 2026 at 3:26=E2=80=AFPM <tarunsahu@google.com> wrote:
>>
>>
>> As Per Today's Hypervisor liveupdate meeting, This patch will be picked
>> by @dmatlack@google.com for latest tmpfs preservation series.
>>
>> I have a suggestion to make here.
>>
>> Let's send this patch as a saperate patch so that I can also use this in
>> my guest_memfd preservation work. This will help landing this feature
>> sooner and unblock other subsystem who needs it.
>>
>> Let me know what you think?
>
> Hi Tarun,
>
> You can include this patch the next time you send your guest_memfd
> patches. Whichever series lands first will pull in this change.
>
> We are trying not to merge new features without an actual user,
> especially ones as important as those changing the uapi. I think tmpfs
> preservation may actually make it easier to land, as it only changes
> the code that we maintain.

+1, let's use tmpfs preservation to land this change. It is a simple and
relatively small change compared to guest_memfd preservation.

[...]

--=20
Regards,
Pratyush Yadav


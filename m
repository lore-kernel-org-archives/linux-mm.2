Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69CE7C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 10:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5386B0093; Mon, 10 Aug 2026 06:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86896B0095; Mon, 10 Aug 2026 06:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D856B0096; Mon, 10 Aug 2026 06:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 792AB6B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:14:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06A331606F9
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:14:15 +0000 (UTC)
X-FDA: 85084949670.29.E30E1C8
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5481F18000C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:14:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZmKdSAIq;
	spf=pass (imf16.hostedemail.com: domain of 3c6R5agkKCPwxevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3c6R5agkKCPwxevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786356853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7bDX99X8heKfUMDjEOLpp44Kc2HBY4XoCrDNhJpdWw=;
	b=ZGrfap3GAjxEcsreSy0kLpdt5JK91nd2wwHqFDvA8F2x3i3F9WhVYK+Ryk1s6pg0QJN3oM
	Hk/wC10gkPh17UBgypA709+RldJpxOdbpBMbclRTMvcyIaEj0PQa8zcPUXque+EQvQuajH
	qRpbsZckXIdvAkz8n8EuMCQ5mYRPntg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZmKdSAIq;
	spf=pass (imf16.hostedemail.com: domain of 3c6R5agkKCPwxevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3c6R5agkKCPwxevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786356853;
	b=uypX+dtAXL51BcCbHTpzdl5LNW/RLvlF4/77OqJkJQgRDUmr8HAH2mHeN9pWUZLlOXJejT
	8Em+W1IKt9LWsbL20cfxuoQ7BZRqbsUxA5U6mf+ZEi7epom86ein/cLEaPtjg24OX4txUn
	at1UEhBr8ui3pNkGYZ/K1gdOZdTjJ9I=
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-69eae8773d6so1929448a12.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786356852; x=1786961652; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q7bDX99X8heKfUMDjEOLpp44Kc2HBY4XoCrDNhJpdWw=;
        b=ZmKdSAIqE8rkBYtP5bnQzhG6DP7Y8xF3Oxo+8weC/h0159MpwJHbnpO6wOmB2Rb3tB
         lAQofPOTOYtZ7bGrSFZGxuMvsMkwSVYZyLghzdjN+RHUQ3CUhNwFT92qq54NV7yaK+MX
         hEzOd5wEje2ISpNKtWxowr5aVnUIFmieRBOWOmaU7ivQmuEcbNEqSWKOX2/DUwmHQfcN
         OAjogd0XjddwuGj6ZrEKrYOc49KYRJtf7Y9UL/hDLULNBIOuIobATvjlF2zla6O6+Wmm
         LC67acziZa+j35z1ZVWXYq6jO6wgYIns8+7iqn+9N4Nj3AbvKVPem+GbnfXWN5Fll5bH
         S+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786356852; x=1786961652;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q7bDX99X8heKfUMDjEOLpp44Kc2HBY4XoCrDNhJpdWw=;
        b=BdWLcken3pG7AFsAl3BYtHwkRibKRuDt84mI78CT4IVt6FAJprFyQ/f/jxOXUmI9j8
         fTjOn+9Y0yDPetAKKpkI8aCgIoogWU3HBMhYozcMrI7Ql10sr4XVbX7vOXOxzE7JWjs2
         1bcEs1N+AYYP59fVU4c1gao7yxVD0c2e1z2xZPslhE8SuEN66EYyNcC4tWnJaTcfsO+S
         Buiaq0Weccr+Hv5Ot6FgJHYcX/TfKDN2AohSj2F7J9SpBZHB4QqiwfD9byjm7nHI3kLw
         98QYMar6j5zom7midAf3zabaYULkWYu5YMX7ong7TyktssvscquH36J0GvEwJMXglx8r
         dWbQ==
X-Forwarded-Encrypted: i=1; AHgh+RolnwzBmFyWDi1j9OISCMwS8rMYHS5hZskvUhmpH4gt5diTmtNka7dxeNkfS8/Tb6FWm8bOPBZe+A==@kvack.org
X-Gm-Message-State: AOJu0YyIgE8G8edzbzLiNV5wgdvriln0DLaW/7xbnUFEsZ455gTifSOn
	tNgIIyk2Evk8/efdc9HMClVw5xJyXy+itU136QB7mei+cRXJB3xhhMoM712KJejid0Zn7qxF/zZ
	qFqyYxkegVpCGD8lT9w==
X-Received: from edtp18.prod.google.com ([2002:aa7:cc92:0:b0:69a:bfa3:e91d])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a00e:b0:6a1:fb92:b3c3 with SMTP id 4fb4d7f45d1cf-6a355e19d23mr437843a12.12.1786356851307;
 Mon, 10 Aug 2026 03:14:11 -0700 (PDT)
Date: Mon, 10 Aug 2026 10:14:10 +0000
In-Reply-To: <CAEvNRgGazT2D-G7sEem4RD5nUEj7dmcg8vx2=3bpatS_o5uE+g@mail.gmail.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-3-tarunsahu@google.com> <CAEvNRgGazT2D-G7sEem4RD5nUEj7dmcg8vx2=3bpatS_o5uE+g@mail.gmail.com>
Message-ID: <9huzh5l28eq5.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 02/11] KVM: Introduce kvm_create_vm_file() helper
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 77rkk6cxds6rn7cgmp7aka63sh4ppuk1
X-Rspamd-Queue-Id: 5481F18000C
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786356853-650280
X-HE-Meta: U2FsdGVkX18vA0Vt/ZwEv/garKp7voeil/FzJY0si9umvidv+OPM0+EhD/oK14iqEVmZuDAM/Irb7MkQw1oAnbff0bnWwupMKa5eKJq5vf9Kjl4ZdDvur+kFjhH5IyKKiOmuHEpL0OWiBiadfAZtiWQFXYEg5mZZX8MGSoPZIhgTFTaQ3/bmiw2G5+j84XIRNa0rCdyHP3BYM/kezjueLziqBZxc2xELeLQlYF3N5IvBEQiTOyHCt0uNYS7pVT9FQcNfFUgD0JZO/l8VtjDpcdfraZ93VDMQ1091q+ZqlPTMutLjkOJmaukOoyMVkUCgyeew665R2JEwtf7kqCGmQdY6k5iPF11wqPXn+IYAPtI4Oy6H4YWaitX++5OsXb2zLl1xzCbzE26/pXsVrw1YK4ZBKbw3+3IZ7xtCcDsPJ/k1J45KtbJmWOCACDnNpKwTlc8li4EiaoGVrSfmASbHEmrziF5x9mN7zIhj//Lckgyi7zLN/75WUAOx+QZemIywTcrAqp9IkBOtt2zvTyE3pzn4MPZei29loLwtDh3jfcfoHCaTpo0UiPjPMTD42RSpAVRPkpcpKamrbkXAHXYmeZjAQUZcwH8mGkgIZI2pKd/nDXwUKKEhwJPJomTLF5SH9681C9vsYEOy9J7va94wAqqNi7Etv/DufeeYwxzHkdEQy3uwn1PeGxrQ6hpytzU6S9zLxU+3v0chzj8W150SgJwcVmjF6w1KjA2LfRYxsocZzYV86+Lu2uU1Bzy6toYijHu2sl+hpp7jTgYGD3uBpUVhD9j6sGsRA0RW9BNMdkzdnBWn7pFvridTpT+e6CIS0rd/eNszOkRoL5AO/Y5P4jdXloUP4O1Pb2O06QWctlmOAUimFqJam412r+ebiHhBO84C9tCFKs1RfGCcEP+cyO+Xr7Q+vPc3UcfxhJGHXGzu1JD9YBUEc8TyyuArGc1dc8FlQ5ZQndNmq3281Hu
 5MjbX3el
 eAPylHe3j/oXJHZoViog/GBNOwPs3xWMRoj742B8ASIg5dW2M0KnJtxepBii2ImO21o9aDVoHFRzUawwxFSinTA7HhQmjHwd04V4g1WlmcGafOoP3R1Lug7Y/9zj7bXvqIiK5UkKLaEqlOwDDs+UlP081IIg0gVQiGejDdYpx/+/lCSuFw8gUInRGiCL4atUS829huJXIgbzmw0rrhii0NwUxBTNQNrZ5NE+Czv8/qTzNEJcfEixGIXIHdNkH1Zourhs//LmtLliKErGc7p2WIb9eRzeKszKR6Fw5tRqD2TR5qj/p1IVSDwX37VjNm1fJa+MDHGyAG6JdmDZOZSRxGvRY0v6BmMvc58nJOI973Gnw3OuDswTJEJPT55qQU3awHGuV45ptTIBArE3+q0QFoAoSePhX75z9q0Z8Z/wMm2j+2hO1zjXHYK3kVoZGyO+lYP99qOkk6r2CSfym75hU0kD4YaXkiAovQPRwFqXIO1k6/fR7a5GtCkpBCBwXACj0pHpnfTmneOZqG6oIGdFd9aCJzoeog8AHnYfasobF2q6vRM+KeBGhP1rjzddecQ9AOqg+UwGGUNb8XBvLgGhNOaY9yBcztkAahbvJzfj11vESi2PHwzT9cnsRUZnoCF1HXwHI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> - Move ITOA_MAX_LEN to kvm_mm.h for reuse by upcoming kvm_luo code.
>> - Introduce kvm_create_vm_file() to wrap kvm_create_vm() and
>>   anon_inode_getfile(), providing a unified VM file creation API.
>>
>
> I think these should be 2 separate patches.

Okay, I will split them. Thanks
>
>>
>> [...snip...]
>>


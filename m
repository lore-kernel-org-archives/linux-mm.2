Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF6D606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 14:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PwJkoISq
Received: by kanga.kvack.org (Postfix)
	id 4F1206B060C; Thu, 19 Nov 2026 09:03:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0576B065B; Thu, 19 Nov 2026 09:03:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3685F6B066C; Thu, 19 Nov 2026 09:03:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2C0B6B060C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:03:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F65D1C43F5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:03:45 +0000 (UTC)
X-FDA: 85452036810.01.9961511
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5BEB640010
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:03:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PwJkoISq;
	spf=pass (imf01.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795097023;
	b=xw2UTyNUYE9Hdz8lbgB/NKOP0ZBw26qBeC/TnUBTe4VNH40hE3UfHsCQTtquY1dkieHbV+
	Y+Qrl69yid4kuytzWcvkhLaiAIW/646E9wnx81zHJfLyrVWK7Kazs3QnQ9K/EbuW4Q/i8a
	W2GFvNGsXhbQuoAnqzve1Z2UK8pelgw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795097023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e11EI5HUYH38rhtF9FVzG/dbODjC6Dq9r2AF5SdURro=;
	b=KOtCzOFPdWPHV/jCiF/2T4O2bzQ8kYhdXvKQIDgIPjbJd67O1R8XgcC64d7uZ4m5CMnfDq
	L31JvvHZ4hwsFyJHX9ZeqhmIdjSHbW16AkMJLKN7yde2UDMYOw+eXJCbZjIvoCzgQ6eoNu
	O6gZDdUoCEFDpD3ElbwY44bnq44S+7Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PwJkoISq;
	spf=pass (imf01.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BE3441083;
	Thu, 19 Nov 2026 14:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF91D1F000C7;
	Thu, 19 Nov 2026 14:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795097022;
	bh=e11EI5HUYH38rhtF9FVzG/dbODjC6Dq9r2AF5SdURro=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=PwJkoISqT6EaC0sZkStTcJo45598OYDzHwp9gfFfqn9uRoAG1Yg4ahZTMuCTvhb7a
	 14xpOeQZfd6YjLY9BVIczZzlXE9E7iIjJ3NsbVI0JOCkkY2tz/Kr7ecx3vErx5PQ9+
	 CL+ZHICinTASfBwd1uhi3TphOs+mOPSsdnkPhLkipU55Ki2z3KmRWnxAEFQVYI8LBx
	 CfYsgHLyAFiKETxHqOQUHqHz5f56AITZz3hiwpoHVUc77y0JFugaO+JAz0TX8HXHzG
	 zCS2QcYsh0tewRa27ni4OzTZQV8L7u9+mocxYaVVuSb0sKTgVdW7047pTiAAPPHHFK
	 Y+k9Mo1jgYSMA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0FEA4198004A;
	Thu, 19 Nov 2026 09:03:40 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 19 Nov 2026 09:03:40 -0500
X-ME-Sender: <xms:ugH_ahf63RW6MbgcteVZgf9zd4Dci0kGEjOq79aATfIYmJ6x9SrE8g>
    <xme:ugH_aqD59hiZYEATE3c8N1CySI58yXhWSdVg_WffAM-NXwZe9bsogkiYPeShZAfHf
    sppKaRxDaq8-VvSFC6mkmO518vV1WiFjPFZjz-9saO6gUP7qIHtJc_B>
X-ME-Proxy-Cause: dmFkZTFZ0/opS/OEdL6TyesgIFYBhyhms6dCId0BZNRlqxIsUc3/R9O1/SEa6wmz3oCDH2
    WHtrVqtIHQRw8n9z7z+CTC/COuUus2sD5ZoLmedmzD4SAGjrhTCD3lmSf5AG9U63xhcFrS
    dyyfPn0Cv5J/7DJexKVDN1qPCE34iUtEVxkcORtHRah84RHeVWuWEleKmFwzh3smpaUTGm
    Li4RfqZVLFlY3rb8OqBLNK8aRzrhSf6AVUR6SYhRMX7Jak0lBTARwL1oRDY4B4/k+9mzHk
    SSfEuUtdN2sVOw2hbhBcwg8uzkTgrE/d/aFBwqHQ010cHeKSYsMwdrlEt7RleB3jZILjj2
    CCooShuiwY6mfuCFWy1K/iIgMBnIP3/b0evwKsMbHPIKGPkZUzYGeeYKM/tIIN0ywJ/MuW
    MumLGaooVbYsQe98lttPjNGhglEGAUbmgKFeFk7/ydi2QdcP9IH5mDbl7/zQUzeasjP5A1
    6eAn1uyYgMstlzu/QvFgozOuvW/CyDJ2pxNZ1Skwtt3MXGJPCPzXHn7/qH+SJ0JQTzvmFw
    z0QWHh3TI0Fc74e9F+az/LtEGTJDBYjLsG3IxW/od+hBLmeXlsuy0CpBjC3yOQcjeow216
    UgJjPbKH5qwrr1SIdMKzzYuGL9x4ZDT4Kx+r97Y3umcvbRG5+HHm+FZKugsg
X-ME-Proxy: <xmx:vAH_ajJyxbbeTJSNijbLLjqsFJ7DlCLzv6mvdc5i3YogxIlGCnpGeA>
    <xmx:vAH_agf7r7zZTDaa6Z9CXr9MCCdAlcoAOkQ3PgZ_66ajmTZAXvTZ-A>
    <xmx:vAH_ai_7X1VcFlxZMQcXPSx-iUM_STg6zaNmhx2ghNFnIzAzPBqIxg>
    <xmx:vAH_atpLDnal8svyG675XQOCWQmwUeGeeOIiz5uT87rzY6TXGS7Qtw>
    <xmx:vAH_anCePCP23IvZSwRq8Ot258hoeSODfjmYOChNPQNf7xI9lYddHe2h>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 6D439F8008E; Thu, 19 Nov 2026 09:03:38 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 19 Nov 2026 15:03:17 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: sashiko-reviews@lists.linux.dev, "Ard Biesheuvel" <ardb+git@google.com>,
 linux-mm@kvack.org
Cc: "Suren Baghdasaryan" <surenb@google.com>,
 "Kent Overstreet" <kent.overstreet@linux.dev>, "Hao Ge" <hao.ge@linux.dev>
Message-Id: <b7521ecf-d30a-4b47-959e-43257baaf8a9@app.fastmail.com>
In-Reply-To: <sashiko-outbox-223175@kernel.org>
References: <20261118132719.632451-2-ardb+git@google.com>
 <sashiko-outbox-223175@kernel.org>
Subject: Re: [PATCH] alloc_tag: Use __ prefixed ELF section names
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5BEB640010
X-Rspam-User:
X-Stat-Signature: sjen6h9j6xay4a6cae98udt3aj6z9kh8
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795097023-496751
X-HE-Meta: U2FsdGVkX1/4tjFabxvTcTaIan0Q7Z5qrzuzF5WZxjGTWf6vod2DazwJBIfguR77S1J/hMrji53JzBee/h4uV0EsgZ4zDvkf7ygksVUJzSg3jkc8Kfq17ac95qaUtZRehI8DjEPVb7nyXlveO4TyuqxQr8xIYY5i5+wYnRdy4XliUc79kTI3c84rNSes+srfO3uxdcWAr+CZJ1aaoYeQA1WPr4YstYOceBOBnjU/N0OMX0TxgJe5dlNAZBV0INNl5rrxQq8WZGsrZvebAJX+OyvtNa2fiKOJLSKlBAZZCBv7BlmRH5MSuqKHgmLL+WIoLyWBlFa+dyGA4iN65PPr4nQdmbEop7anx+LOE8SLdcd/M1XkxE1ACglCfIr8iT+i7mAinbh1c07ZSaNZg0IeTTvVsS+HC6/ttJS8xyjBh7GZgMdM/BMJwOEVNYF0GAUGR58ZIuo4jj60FNiC5rCV0RpYjQdWSFOUzZ9JdfbhKM80G/ppTtRQme3f2QrnsK4LR67Hv3u3RhbujW5I7Hm3CODaSvWZO28EFSSY6qqYk0RKFtGU8Pa8PY5lwPr0lbe6RKy0RcqEjOrL5wEU/epRwJWI67sZY3PnHUwGxQmYEky3NjamTWZ/AofiqX66Dx9yn8eHPPibO+2HvMfG3SlXkQDvUV4NDrmoU6fdFX80eKPWrMVwsAIa/FA3yvkURH+KrjyR0ac28WHVInanim/rA7+r+QOJTdQTuefCdKU+HbVJpm9Gdp9YYRaiPUS71G2HU/GzzMy3ReVx16X9e9NveRJ4DMkQ9UrjiysDKe8qso7wJ1np1TttVGUkgIoyo9KQG1MX8dDJQDxDM/0SeQhuNHvTNSSq7F+IX7IMzaVyPlnlnyued6y2JIH1gyp2lV4IJamYa2y5zzCDbyaCh9dsF8YoUMO23H7qol2682vpoHaUtIeOzSnMx7fUjhs31Eg9nZHd/Ns2rzDrw1sl61Z
 9bVUd7Jh
 q7R/HBijEwKzbtWaaewbvoM8byDNl2FMwPPZaWdqRWsfUhoh4LTqsf4YYrvqyUaRsOCktb6rM3KIAr0Eqpv5QeWFrhXKNvysWMzKV86t34NIN57x3nk/vy4BS6wnmoy2oCveKZmWvl2WwLDjsXoSsZQwB8DsXfZTgOLIyATiZATp7hD/0cMVTLG+Rw2OvkrEItwcIawws9Ro3HzEk9xcDktEcyPE0J8DK6eQthUPW5w/9qiIGRepfcFgfMJNFH4tUz7oDMsEyKVELjrDiOMU0+0U2RjTTui0OZBK2oH3VtZUmZM97DN5QCdUszPdRsPYqKAFRdTEUrBtIAxOoTESlEens0DIYcZ4jtKKaGKfMuwFz3F6NwniFbmCCbMzDgJdpVpJF28sFdS6u0F4wNJ1okpo8AyhoIwFXzNLgmDC/CVvblXuJX8kTXYlsoWxd2C8xLrWYaUyXLzDuT2806peV3pVRJ8yo/FLLuFabK8x4WTYIyyFrf38Hu+MdOY/HzWcuCKPLULlWKkC6EsuAyx7pKu4kpdQBYhCRIjA9SFZpe0W8SsQuV0n5PIeoxkIgifHNTEh91XNu+kBfuuPmDExPWF/i5xTecwsADI5O9+J1PmXMB/JJvkF7K7IwDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Thu, 19 Nov 2026, at 14:27, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [High] alloc_tag: SECTION_START() and SECTION_STOP() fail to expand
>   macro argument
> - [Low] alloc_tag: missing Fixes: trailer for unprefixed alloc_tags
>   section name
> --
>
> commit 933587991e6a16ab600445b22347397f80335de9
> Author: Ard Biesheuvel <ardb@kernel.org>
>
>> alloc_tag: Use __ prefixed ELF section names
>>
>> The compiler will emit static relocations related to a section .foo into
>> a separate section called .rela.foo, i.e., it just appends the section
>> name to the string ".rela"
>>
>> When section names start with . or __, this results in relocation
>> section names that are correctly matched by the various pattern rules in
>> the various linker scripts across the tree.
>>
>> Without any such leading delimiter, it may lead to spurious warnings
>> such as
>>
>>   >> ld: warning: orphan section `.relaalloc_tags' from `init/main.o' being placed in section `.rela.dyn'
>>      ld: warning: dot moved backwards before `.rela.dyn'
>>      ld: .tmp_vmlinux1: section `.rela.dyn' can't be allocated in segment 1
>>
>> Fix this by renaming the section to __alloc_tags. While at it, tweak the
>> headers so that the definition of the name appears only a single time.
>>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Kent Overstreet <kent.overstreet@linux.dev>
>> Cc: Hao Ge <hao.ge@linux.dev>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
...
> Does #NAME in SECTION_START() and SECTION_STOP() stringify the macro name
> "ALLOC_TAG_SECTION_NAME" instead of expanding it to "__alloc_tags"?
>
> In alloc_tag_sec_init(), kallsyms_lookup_name() will look up
> "__start_ALLOC_TAG_SECTION_NAME" and "__stop_ALLOC_TAG_SECTION_NAME"
> instead of "__start___alloc_tags" and "__stop___alloc_tags", returning 0
> for both.  When compressed page allocation profiling is enabled
> (sysctl.vm.mem_profiling=1,compressed), kernel_tags.count remains 0,
> causing idx_to_ref() and ref_to_idx() to misclassify built-in kernel tags
> as module tags and dereference an invalid module_tags.first_tag pointer on
> page allocation or free.
>
> Using __stringify(NAME) instead of #NAME would expand the argument first.
>

Ugh the token pasting stuff always confuses me - I'll fold this in for v2.



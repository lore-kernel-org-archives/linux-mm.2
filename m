Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7EDBCCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BF078E0040; Fri, 17 Oct 2025 04:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048398E0016; Fri, 17 Oct 2025 04:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C2D8E0040; Fri, 17 Oct 2025 04:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C43BE8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:16:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 776AC11A6A5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:26 +0000 (UTC)
X-FDA: 84006899172.23.DB16DA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4499100012
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=eFU5zW51;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760688984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=vTcEXIa/qyIxq1EqyFH4TJZP34QDmpKRKAZA3lq7x4I=;
	b=cnKbPtNuhy0Y1p2eqERyP9mgJYH3iQLZJCzIdK0Xss0FLf9JoXT1EenZdnadqFmVX8pxEo
	uayvXeV9+xbHubRmJG8Stcc7wTolvkrPnZS/OWvxFm46ctPRFQJHYCHvv8MLGE0I7jfxzE
	4ApwqYlKGN569++IQGADIFCnJZVYEO4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760688984; a=rsa-sha256;
	cv=none;
	b=ONYSu+fFsUbnvOhBhN9YSS+NVljIM5WBkksp7rixOoanOI38DcPTOWkYw4P2ImSE1V6JkW
	10zlRKevGNWKIRI0D7XH/eTzaGVfob+NzAQIFxHolKiQQy3fv23d+QPCztappLboIG0s2d
	cYR0gjQqAen193G1fWk+0Z8r3qSsF08=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=eFU5zW51;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 761D664284;
	Fri, 17 Oct 2025 08:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9750CC4CEFE;
	Fri, 17 Oct 2025 08:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760688983;
	bh=esjZ5c3IUl4375FObJ47mVUZDlqGA9IJyPO9/OsyVAo=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=eFU5zW51H8GlFuj3Q/QUy0tmyG1EuuKTzitri78rXVhmw3lYFNKJWmnjmWnhWKo94
	 Hy7c1vHt3j3dpdJNDY2xnoLrT0yTl+ztJBovPwzauyD5RAX9BMQBUrEx8fgNuV0FGP
	 DzlgI57Rpvl06doQb6YCE+HdJq+9WvTQL/VXO0uk=
Subject: Patch "minmax: improve macro expansion and type checking" has been added to the 5.15-stable tree
To: David.Laight@ACULAB.COM, David.Laight@aculab.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	arnd@kernel.org, bp@alien8.de, clm@fb.com, coreteam@netfilter.org,
	daniel@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net,
	dm-devel@redhat.com, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsahern@kernel.org,
	dsterba@suse.com, dushistov@mail.ru, farbere@amazon.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, hdegoede@redhat.com,
	herve.codina@bootlin.com, hpa@zytor.com, jack@suse.com,
	james.morse@arm.com, jdelvare@suse.com, jdike@addtoit.com,
	jejb@linux.ibm.com, jernej.skrabec@gmail.com, jmaloy@redhat.com,
	josef@toxicpanda.com, kadlec@netfilter.org,
	krzysztof.kozlowski@canonical.com, kuba@kernel.org,
	linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailm.kvack.org, an.stormreply.com@kvack.org,
	linux-sunxi@lists.linux.dev, linux-um@lists.infradead.org,
	linux@rasmusvillemoes.dk, linux@roeck-us.net,
	lorenzo.stoakes@oracle.com, luc.vanoostenryck@gmail.com,
	luto@kernel.org, maarten.lankhorst@linux.intel.com,
	malattia@linux.it, martin.petersen@oracle.com, maz@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	minchan@kernel.org, mingo@redhat.com, mripard@kernel.org,
	ngupta@vflare.org, pablo@netfilter.org, peterz@infradead.org,
	pmladek@suse.com, qiuxu.zhuo@intel.com, quic_akhilpo@quicinc.com,
	richard@nod.at, robdclark@gmail.com, rostedt@goodmis.org,
	rric@kernel.org, ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	sashal@kernel.org, sean@poorly.run, senozhatsky@chromium.org,
	shuah@kernel.org, snitzer@redhat.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	torvalds@linux-foundation.org, tytso@mit.edu, tzimmermann@suse.de,
	wens@csie.org, willy@infradead.org, x86@kernel.org,
	ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 10:16:15 +0200
In-Reply-To: <20251008152946.29285-12-farbere@amazon.com>
Message-ID: <2025101715-condone-trump-9dde@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Queue-Id: C4499100012
X-Rspamd-Server: rspam02
X-Stat-Signature: zenn5bm33oqqb3974choy8ytnipzpd95
X-HE-Tag: 1760688984-33323
X-HE-Meta: U2FsdGVkX181jumJN2mgWJ4cZUPPYG7gVf06DrqX/IFjWtHuSYGtjJJu/UQSU82pNejX2hTB2d+OVbiQ1EFVnC6e2+HD4j0DJrYHdWloQZMrN2z9iX2XL/itVKecXobdHfDHtPdiFLiqTzfhr+8MgzLv1uJmFhATgb1iPRpuynIh1UhWjZMXNohEFcL/U7JPiX+RCNqcId2PfCf25DmUHARE2el/9aIXn2JIoSz2MmS9md3IT1KkV2uudk6yXZvCCFeNTZHUO6O45SAH+tLybIgDPlsQSyJbUqaRKFFR4ghr+4pPgOQNEdTYbDq17vyVWJRPtTDUOZXr9J0QnMowegipJweQxK0hrRmfiiE2KkY7rDMQScsdeG4R+ar8DVLv2wv7ZwEyF6eWfrw74t2QhFSFvNButtoTvt2oGKiKwGoKH68YhyBFFOBH6qzQQPjfZCVohJ9REW1Y3BSuuNrywxD4nKhk/UganhHmTcFREQUae7VCvqyxjQIfz2quwJPKIRD7xFA8dU4+D/u5SrHlI8c11a0tUuIOeiC1U/sRxTBEhhMxdeC7hJvbVGLl2a16psFdu77QY5CWB8hiX6qzllj9uoSTIir9tqOe1ee0jRNfj/P+YuTerbCqpS3QPxOYcPYvRpuRLl+T1gacIL0RI4L7wkzHwL6VJJpECOhYuTpDCLFggsQ78mxf8yZNYLF0PrSLumqNw4DbFZfmPcCz0XGsYmXa4aI9Pu6ejPhZ/V4EckQiUxXKQNtPbLbCVyU4Qtnm3O8GoWir+/LP5WCIl1/G9JI7eD19PIUUIMUu/U9HfnM+b6flIyPkbSwY8W+iqWLhl+qLiQYgoMhrhOyklGDUTW40R3zWR+cUJnUaNKSM/9CLQdmjzvJjvNaczxGdPn8RlgyAXoJGOMQ7WbQTvR5kgadL6W+ljK4SZBhFotsIvTdkiO/8dUJa4Ps/6z+i4O5DYUIJd985Dkp/omi
 uGIWfDeV
 0OG3QlC9n5cP3+TsUxhWZXjqd0hmjYzhSi1W8oB0gWZ+AoAwJlT+KmEdRfds8zkwYxbqSsneLK2zjFdt47w0PrqSQiz4FZPy8Ce3W26Hc5Er7wdkZHMEfff27v/8WILe6FBuESRSoiMacTonbFKsYkKAqJmhvwIf3AETOUvxc+Yc8cOxNreDmwS7AsOfK4AFAze5ZuQz+g/TriimqBDifjM0EEevCf11tvAFRtOFLPBdsAOcnT8zuHMWzwJ+c/B1BM/fJfcO3Eu/Yb6i494CXx0len5ON6AcDBkmk6imrz81gqDFdBQwfF+jvJVygvLwDgNtWC4EVFcs8un5GBbaJGT3fPgwiX+y0zsO0JvgXRJGX51hBbcG1wq1Bdxp8mJ+NJv35CmxI1alcZDKbzQTHA6lBs2uopFpyE34remLDFn1sZAcKhO+F/6dlSblV7wQDZeifvQ0c+rqxIueyX32ESVwt6ObpkPY2rz4sFSbwBWv6Y7ChCe3cM10GxZWKete0lEzAed33AivYzOs0kk07Ag9nmql1BDRMyEL10puRZ2d0xWc4f/2qEM2GTNixov7na7LwCbddndXlToNgfhK59mkU9wNEVApfM0H0ugW7422inXWcRA06nch8cJuOcHUJxDqkjtBAwirRrSYlDOh0C0PtX+/Lb86YxcYNIotDH6hyDNQww4iEsx8wWf2eQquR2G/rWg+D1sENZVt/By5yN0NokSOxieYyOxrQdheG9qC1kP/FMnV5HbZdKvwXcGdoUfxIRNxjXdC11Dn5eQSHqZljAzUTH7vFv2zluG9XIo90SaJER6hDTCYauCE9d3ZjLZQQ4kHdVWgjkx5xy8JFugxFF3A61iori9XH9dCwHR5h0iRwoOH/iXhagH01Gn4duWwuUYRwY4LZbFzKoI6IsxE5+AYht8XPRM/D7gPT4NAOabtfkYpMPsJ5ilHFoZ/GPQa92Et/KbFfidZ60ADKjb1fothe
 Bv8snyR3
 VLgJkiNXCA7BwgbBmObmI+eZFvGSlJGehIQB9kCOVI3bBOogczAfnsD0JCWy3VWSSzSxj98oKrlZ9L1OPvBg/gYlp7fnvlgYWOD8qksR6DTtVAYJfva+KqygtCo0cL0c6+FplZ7KeiyqPrksAtprapilbKAQumOQ6rhkJ4X6eKJbwL9NUvaJxAz1T9+K1q7Us7rrECUzJ6pJItf+XeW4oGlj7d5UChLLN1wMgQNy8nXBkpbIY0SFHjlCOv4sOY6Ew2f2p63k3zedZ0U6L4VpyKr+8nfND3weMLdJFubqnk2j86/2BpvrO+97UDMTiuKHn5UyMudXiGLVAULGqUDBRBiN9fMIZPWmcWP3IjkNizZb8OpZO/CSqiuUoAS3KyL7+jYUcjiMp7OhCo1z+AH0iY+3lgMRGEqKckbb5pRikwB6Kt4xdGPCE+vbGgeJso1U7E4ipVe/qoL6CcjjnvDSiKMeAgQN0E1DyIFbjajHP3jH7L6HSpwIPuJVdJZs/l1/nb/b+kHe7eQvmT0rGoubDPCHIVQvclNJ1BwFpuWUDFgkMQs2rzCw8AwG8OdZX+rKjeAL88O8Dv25dZq90tzcdRmN/jDYUHEvfIgu65M+oLEvqZuuLctE3HFA1arUhbiKHNWsPQwB5NKVJD4fYkmhcNVzmMbmdmbzn5zV1l9AMC1QSXzqK1xdPJth0FvkXkm2fqRsnzaWVGsSAiFTA/u1TnKdsX+acWybwzTlS+P7VouwZgdRAYuxc0TNsmnrcuE762HBubImLkC9qUQYKWSxFaDJP+w4vP5Jl/mTzVFoduquyNvThcumrANwViOzWElVRkUDv4KPFxb2EE4M5uwqRBhC0oGPHcms
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: improve macro expansion and type checking

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-improve-macro-expansion-and-type-checking.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=36971892a=farbere@amazon.com Wed Oct  8 17:33:00 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:36 +0000
Subject: minmax: improve macro expansion and type checking
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Arnd Bergmann <arnd@kernel.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20251008152946.29285-12-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 22f5468731491e53356ba7c028f0fdea20b18e2c ]

This clarifies the rules for min()/max()/clamp() type checking and makes
them a much more efficient macro expansion.

In particular, we now look at the type and range of the inputs to see
whether they work together, generating a mask of acceptable comparisons,
and then just verifying that the inputs have a shared case:

 - an expression with a signed type can be used for
    (1) signed comparisons
    (2) unsigned comparisons if it is statically known to have a
        non-negative value

 - an expression with an unsigned type can be used for
    (3) unsigned comparison
    (4) signed comparisons if the type is smaller than 'int' and thus
        the C integer promotion rules will make it signed anyway

Here rule (1) and (3) are obvious, and rule (2) is important in order to
allow obvious trivial constants to be used together with unsigned
values.

Rule (4) is not necessarily a good idea, but matches what we used to do,
and we have extant cases of this situation in the kernel.  Notably with
bcachefs having an expression like

	min(bch2_bucket_sectors_dirty(a), ca->mi.bucket_size)

where bch2_bucket_sectors_dirty() returns an 's64', and
'ca->mi.bucket_size' is of type 'u16'.

Technically that bcachefs comparison is clearly sensible on a C type
level, because the 'u16' will go through the normal C integer promotion,
and become 'int', and then we're comparing two signed values and
everything looks sane.

However, it's not entirely clear that a 'min(s64,u16)' operation makes a
lot of conceptual sense, and it's possible that we will remove rule (4).
After all, the _reason_ we have these complicated type checks is exactly
that the C type promotion rules are not very intuitive.

But at least for now the rule is in place for backwards compatibility.

Also note that rule (2) existed before, but is hugely relaxed by this
commit.  It used to be true only for the simplest compile-time
non-negative integer constants.  The new macro model will allow cases
where the compiler can trivially see that an expression is non-negative
even if it isn't necessarily a constant.

For example, the amdgpu driver does

	min_t(size_t, sizeof(fru_info->serial), pia[addr] & 0x3F));

because our old 'min()' macro would see that 'pia[addr] & 0x3F' is of
type 'int' and clearly not a C constant expression, so doing a 'min()'
with a 'size_t' is a signedness violation.

Our new 'min()' macro still sees that 'pia[addr] & 0x3F' is of type
'int', but is smart enough to also see that it is clearly non-negative,
and thus would allow that case without any complaints.

Cc: Arnd Bergmann <arnd@kernel.org>
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler.h |    9 +++++
 include/linux/minmax.h   |   78 ++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 70 insertions(+), 17 deletions(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -259,6 +259,15 @@ static inline void *offset_to_ptr(const
 #define is_signed_type(type) (((type)(-1)) < (__force type)1)
 
 /*
+ * Useful shorthand for "is this condition known at compile-time?"
+ *
+ * Note that the condition may involve non-constant values,
+ * but the compiler may know enough about the details of the
+ * values to determine that the condition is statically true.
+ */
+#define statically_true(x) (__builtin_constant_p(x) && (x))
+
+/*
  * This is needed in functions which generate the stack canary, see
  * arch/x86/kernel/smpboot.c::start_secondary() for an example.
  */
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -26,19 +26,63 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-/* is_signed_type() isn't a constexpr for pointer types */
-#define __is_signed(x) 								\
-	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
-		is_signed_type(typeof(x)), 0)
-
-/* True for a non-negative signed int constant */
-#define __is_noneg_int(x)	\
-	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
-
-#define __types_ok(x, y, ux, uy) 				\
-	(__is_signed(ux) == __is_signed(uy) ||			\
-	 __is_signed((ux) + 0) == __is_signed((uy) + 0) ||	\
-	 __is_noneg_int(x) || __is_noneg_int(y))
+/*
+ * __sign_use for integer expressions:
+ *   bit #0 set if ok for unsigned comparisons
+ *   bit #1 set if ok for signed comparisons
+ *
+ * In particular, statically non-negative signed integer
+ * expressions are ok for both.
+ *
+ * NOTE! Unsigned types smaller than 'int' are implicitly
+ * converted to 'int' in expressions, and are accepted for
+ * signed conversions for now. This is debatable.
+ *
+ * Note that 'x' is the original expression, and 'ux' is
+ * the unique variable that contains the value.
+ *
+ * We use 'ux' for pure type checking, and 'x' for when
+ * we need to look at the value (but without evaluating
+ * it for side effects! Careful to only ever evaluate it
+ * with sizeof() or __builtin_constant_p() etc).
+ *
+ * Pointers end up being checked by the normal C type
+ * rules at the actual comparison, and these expressions
+ * only need to be careful to not cause warnings for
+ * pointer use.
+ */
+#define __signed_type_use(x,ux) (2+__is_nonneg(x,ux))
+#define __unsigned_type_use(x,ux) (1+2*(sizeof(ux)<4))
+#define __sign_use(x,ux) (is_signed_type(typeof(ux))? \
+	__signed_type_use(x,ux):__unsigned_type_use(x,ux))
+
+/*
+ * To avoid warnings about casting pointers to integers
+ * of different sizes, we need that special sign type.
+ *
+ * On 64-bit we can just always use 'long', since any
+ * integer or pointer type can just be cast to that.
+ *
+ * This does not work for 128-bit signed integers since
+ * the cast would truncate them, but we do not use s128
+ * types in the kernel (we do use 'u128', but they will
+ * be handled by the !is_signed_type() case).
+ *
+ * NOTE! The cast is there only to avoid any warnings
+ * from when values that aren't signed integer types.
+ */
+#ifdef CONFIG_64BIT
+  #define __signed_type(ux) long
+#else
+  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux)>4,1LL,1L))
+#endif
+#define __is_nonneg(x,ux) statically_true((__signed_type(ux))(x)>=0)
+
+#define __types_ok(x,y,ux,uy) \
+	(__sign_use(x,ux) & __sign_use(y,uy))
+
+#define __types_ok3(x,y,z,ux,uy,uz) \
+	(__sign_use(x,ux) & __sign_use(y,uy) & __sign_use(z,uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -53,8 +97,8 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	static_assert(__types_ok(x, y, ux, uy),		\
-		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	BUILD_BUG_ON_MSG(!__types_ok(x,y,ux,uy),	\
+		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
 #define __careful_cmp(op, x, y) \
@@ -70,8 +114,8 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	static_assert(__types_ok(uval, lo, uval, ulo), "clamp() 'lo' signedness error");	\
-	static_assert(__types_ok(uval, hi, uval, uhi), "clamp() 'hi' signedness error");	\
+	BUILD_BUG_ON_MSG(!__types_ok3(val,lo,hi,uval,ulo,uhi),			\
+		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
 #define __careful_clamp(val, lo, hi) \


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-5.15/minmax-add-a-few-more-min_t-max_t-users.patch
queue-5.15/minmax-improve-macro-expansion-and-type-checking.patch
queue-5.15/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-5.15/minmax.h-simplify-the-variants-of-clamp.patch
queue-5.15/minmax-add-in_range-macro.patch
queue-5.15/minmax.h-move-all-the-clamp-definitions-after-the-min-max-ones.patch
queue-5.15/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-5.15/minmax.h-remove-some-defines-that-are-only-expanded-once.patch
queue-5.15/minmax.h-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
queue-5.15/minmax-simplify-min-max-clamp-implementation.patch
queue-5.15/minmax-deduplicate-__unconst_integer_typeof.patch
queue-5.15/minmax-simplify-and-clarify-min_t-max_t-implementation.patch
queue-5.15/minmax.h-add-whitespace-around-operators-and-after-commas.patch
queue-5.15/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-5.15/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-5.15/minmax-fix-up-min3-and-max3-too.patch
queue-5.15/minmax.h-reduce-the-define-expansion-of-min-max-and-clamp.patch
queue-5.15/minmax-introduce-min-max-_array.patch
queue-5.15/minmax.h-update-some-comments.patch


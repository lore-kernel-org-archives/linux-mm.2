Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 228C7EFCBC4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DE656B0148; Mon, 16 Mar 2026 02:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C776B0149; Mon, 16 Mar 2026 02:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0606B014A; Mon, 16 Mar 2026 02:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8FCE6B0148
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:58:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80759B85A9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:58:08 +0000 (UTC)
X-FDA: 84551021856.12.917C39E
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by imf09.hostedemail.com (Postfix) with ESMTP id CF54F140006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:58:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3_am3aQkbAIQ067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3_am3aQkbAIQ067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773644286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=b0kUySBuU6Ume7jaBtPwcWKvQPPEY6e6MvBbaQw0SnE=;
	b=zNfJg35AEpsyXaIyjM2BJ1iCxmGAsp1ymmDQpDSaCmiyW9ql9TpKZiUa2yN+lt8scL6Kks
	VOm6laM+7cJA7jreXA5HwGdfVSoejEStqCn6HNd5/jIYbtyPZTWG18NWgFk2mOFV6zp0YH
	TMYWOSwrYDamqdfiJuEx33365Xv/T9g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3_am3aQkbAIQ067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3_am3aQkbAIQ067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773644286; a=rsa-sha256;
	cv=none;
	b=WP+zfqg+SqKacQ9qtv32Uz+6HmMgL59TGh7f5fgLxRqea5OZUWkzj4qAe6Y6+fGzToruc9
	kiv89cgh09AgjW0cmYD/2zI+p8VynXrmgLhzX+JAdZNqYKMz8GGHQp4LD0SqhWGYh5IVch
	eaJB1IIRgDSCv4c1b+f1et+rK4ftKbA=
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-67bb57af478so5380929eaf.1
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773644286; x=1774249086;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b0kUySBuU6Ume7jaBtPwcWKvQPPEY6e6MvBbaQw0SnE=;
        b=CGPKN5KlCH+NEpU9fOheCYnI8T25LuFHaNayyZXIBiG5giv+m5JiKp4wU8JrqNDtbC
         sNySs3bRa9ucySW3MWSwS3LQM2FvKPtvc1atUAxvTTV/NsxWWVQYA622/Isr2oNnCsDW
         U4E14RmMYGoKMb9BAez0nihleiKV4tHhkPcPIcY/0pQamlXwCGju5BcpuKqZI66fPANP
         McEoiPTEvGJny6ik0l2IPnNs4baJ87R3fpMPOUuJGYMrMKJYsnOuITzzEyYVB8+tFGdF
         RPjbaYJ3tSO/3poGmGHqzy+gSl8NyaJ1fmC5ZX/ZA+jzkaNfZbvv8AI2+dj4lLla/zKb
         YNFA==
X-Forwarded-Encrypted: i=1; AJvYcCX94cWkHRiiQo7xUwX2d3+CFilr49qXRXYsXOcs9BeHvh6+bnetNTWnycMpYF4qrM+jTZEzzZfmSQ==@kvack.org
X-Gm-Message-State: AOJu0YxUN3PoLQEkagoluTgWA6/A7ukh9kGIC1l+XNiQN9gmEVbIKwyu
	o/s1UKeEH2Vc36h8DNBww8smr0tHOEBAofxKh4o/i6vr1RFc2IHXJViHgR9a3vN9LwRUnKJ4Esr
	Db0aS/uYa3SgYk4L9zyXro3vQbRwMIsRcrbGJDMtA7dmm/Mbh3cN1JSriS1o=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2918:b0:67b:c368:135b with SMTP id
 006d021491bc7-67bda9dd424mr8968791eaf.33.1773644285983; Sun, 15 Mar 2026
 23:58:05 -0700 (PDT)
Date: Sun, 15 Mar 2026 23:58:05 -0700
In-Reply-To: <abehBY7QakYF9bK4@hyeyoo>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b7a9fd.a00a0220.3b25d1.0023.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in folio_add_new_anon_rmap
From: syzbot <syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, harry.yoo@oracle.com, 
	jannh@google.com, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, peterx@redhat.com, riel@surriel.com, 
	rppt@kernel.org, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF54F140006
X-Stat-Signature: s5p1faxf1sob9bozcxuhupbyid3fjywk
X-Rspam-User: 
X-HE-Tag: 1773644286-110610
X-HE-Meta: U2FsdGVkX1+2RddK1xmXf+/9OgBa/1NplNLWjuDiBc6JzwzqICdV4urHwg2VRaxGKVR1kyURHfjBANuAIhMvFQh3lM9TDd1NNvN2De8VFwCgfGC+SB5dyfyiGf0R2Q71suTF5BLJ3iDXniyhBpOYFpBdcSgjurfG4ly+GMCutYCG9qpFBNApJNISNpfJoGKhBVw/2lrqFJ+BqKu1Bflw+FAV5DUYy8NwSDOoQV/fxeNa9cPF7sxABJFeMod5rDF9a4IKvFGsR7Hr6KlvggKW8Ppq15WY9I0WkFpuCyhMe6kCyS5A0UmKtNpSsHI2a+F8ohXrR4ymOpbyif14bLj3vPooI1hFTZCAB/vCQasa7PmfcuiNh2hnmF+i/0YncmmTwlVj0SvhZsSWR9bjTo9KGzT9r7XlxcG9syDbxkyawitKyqvwv+Bri6JNB4e2LZssZ2TvKajqW5xCWboWyAJZkiDMKAXa3l5/PDycVP3B98fsK7uhVSFE/Nrm3y4NrspP4DmISyB/vffolX4FsJfMs7Kjwevkg97sTCPgtE+UjaIIJFF0vNKnLIrHL8MKtnjfN/sYGRjiEsrmpD5ye76o/1hjz0w2sv0ZEwUXJXwBcUnQtgnllmBHpt1MsXF1R6R3Am//mPvfdyjUtQs8XXLJnvZPxabqLJtCAOhVxuwZqJUJXzOgIHpCmpktCNUpi0pOg/oUaTa5p0dnFbYdqHMgfq+7ZziDWYiJ1hU9VgOjox91DArdmpw+YijjdCgn1ezgu1ucv3GogL7qKuyMA5eKvGpnYTpzc/+ImGgP7kCjnvH7ZH1JOAb3N+7daY3JedvRV7cieeJEgM/Ugo1HizxhLZ93rQNH16zEJjObevmOfLEgvcwLo94dd8LpHcRAmg99FcLL//gj+ZX6IeWqqAC0AAuPcMOuqyECgAhpWUkmixhkfbSMx0ex4g5rKiXJAqkzS145+hHHmWzozvkiHbC
 PVeckxF3
 LMbPCwhziD/QLr3umrZrDwTLszqsz4iu9qNfOI7yrYG2RcL4ZVQ/MrwmMdGy7xUEBjJ/Sn/0qSmU5X7u92R27YYbFR7uuKyqMrUciPtgYRffLoka2NbwsqDAslOJv+5EmBAiDkpJ+NyjaspgHvxupV1Z4A1ZY5sf+n9mVPawH3a06bxrmQreAN5y7xPOGHYgXqEoB4VWrbWYHD7YKR6x31b4YxJ2vTNfTso8jhi3xOLfMmwUMU9Q5vhjmQqPjNWISvxWpfclpRi9FgMovjV8OfVUYftg3BqcQVp4OvNWTDzXPNc22CokH5ri9qIVTq8JWt0aT3MJQwB73tn5xKBSJd1GW1GYP1nP3LJ6zuqAkXYzDhk3apQ8cE1F3Ol9zsHgvu33/5TSjmiEoClAh6NU/zO4uqlqYnHoTHtP5YYlVLh2w44qT0QGBBw3+z0x3Bmr2v1j+qzu/TuV+o42bbZmoXJ/zKvaP3CzmTtw9wkJgqxd4aDfExB5C9EN4Ru0r0hKjzUliIMxWuALrzdnWwMIEak9lT2EMrF57P0QAAI83JRcQVehcH/WMUvL6p0WfZ5DJUMDlsvCiSs3uat/E5Zm+H5VukC975yiJiNsesqA6LxvcuADVaBMlNEDU/kb5KpefZmhGODsIIKUC9BaFO/+ennv+A1kohVZFaroio4aFIW+uVlQyv351mDCBYpNwQdiM8+AaQJvJQtOuCqEIuiGMY5Td6vjPV+t1RhES7OT5q7+otmXoy+sECQ+ht1hIjkaB6AAoM6k4A2wjO3ilVRn2pJxQBjXhrThYZ5zGFozFD+chI1NvVm48VaJ0bpfZ0Y4948P5eyDUPgOYrp9jqbfx3EDQewg/Ub2FzbIUz+oZNPINLaqXn6NczvXEh0jM4crx+7SdvesRNDc/4aqOx4jkC+EeSemJnG++t1pzB9spBT84iFRMnwjuLXKMhv2O/lOAfz+W1VFOIci9F7e75OWYv1j/0//x
 bL3p/eHe
 YEuVoy+I4URpn/n/CTi6W0lhq7NWIqD/DNANeUJkK7Ju0Lp/rzT0USuyNqXwCS6Fkjw/wu6gHGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com
Tested-by: syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com

Tested on:

commit:         b84a0ebe Add linux-next specific files for 20260313
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11f43406580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d079c776411aaf59
dashboard link: https://syzkaller.appspot.com/bug?extid=e24a2e34fad0efbac047
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16cfdd52580000

Note: testing is done by a robot and is best-effort only.


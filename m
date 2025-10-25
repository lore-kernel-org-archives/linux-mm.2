Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5663CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 13:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9CBA8E014A; Sat, 25 Oct 2025 09:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74A08E0135; Sat, 25 Oct 2025 09:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1C18E014A; Sat, 25 Oct 2025 09:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C490A8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:29:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 710D1C014E
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:29:05 +0000 (UTC)
X-FDA: 84036717450.13.5626EEB
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	by imf19.hostedemail.com (Postfix) with ESMTP id E8BA01A000A
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:29:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3n9D8aAkbAIIy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3n9D8aAkbAIIy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761398944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=DbYZ6WDm74sbp+VcW5jO4pV+eBPk+8i/6WmBuNgclsk=;
	b=vtpf6y+QIczv4hVNqPrJTu/HQa3APiNiwVQS1K+b/zEh3F/BuqEcgIZKDgnVR4EcO51TWp
	UlapBqPVidTWtszKpo1ztyyIKXM/Wo3HlhJF7zdhID+5X7kWVVYecATlZkZ8ITToN0EIX4
	BI6mXYnth09K/de67lRhzwadf9h2ivQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3n9D8aAkbAIIy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3n9D8aAkbAIIy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761398944; a=rsa-sha256;
	cv=none;
	b=ucwAefCmvCXhpR6eY64EFNg2dcyag+uvq0ObOfH3PvvTRgIVI+E9YNDA9iJOWZ3RADH72l
	5O8AMtZCu4nsxXsCLHB/N86xeSL2rENMiFpBuu2H57ZiJITHo3NpyeHnm/tbRqf94NR3sK
	f6kfMVkrVCY3ORPK5FlsR686I7uyjSc=
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-430b0adb3e2so40841215ab.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:29:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761398943; x=1762003743;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DbYZ6WDm74sbp+VcW5jO4pV+eBPk+8i/6WmBuNgclsk=;
        b=fFE4A1RbwJBNuZBJjezRXQAHWje636b/eCLjP3OQg59oxUz+uSpZZGkJn8JxrHtIGC
         ByhBHRQaVorvNOAxGa6d6+1aNT9uL9Ui78bLExCdYISjxumaCgcIdihywKc6sDIlfmTe
         4nI1JvqaxOAmo92MMr7/QYHVODqIvuHvk8DxwN5fmBGOOxePJax26ny1Tdzdb8nlZzug
         AJ1aEP0n5XMp5JJJ0AP1+MsmOynzLL0K1eYY+UwdshJtYyiWsxAaTTNQ0c3d0k15vd/o
         +0+qFo2WS1tpYzWCpxgnSuIwYpNYMAgq0tznskmiBF201MrcY5BQHK6xXj18ER51Mura
         RSig==
X-Forwarded-Encrypted: i=1; AJvYcCWPZpgZNBo0MKbKIHsbC8HqOHA+f2ND2DzPrXXAXGVtTCk7iD+DW/594KfTqv0FxTNpJhk95TxPSg==@kvack.org
X-Gm-Message-State: AOJu0YzQmgPZPhf5erleMpIH9cizDJe5vu6SaKtXaVlrUJbuHuSFw7Qw
	t9WFEAu1LSK7zXLy7xgpTS6DGWQJ9hEX1eVEx5N7WGYOsLMD4z43e0Ry7qSQBYsWB454NDY8nsf
	KcD4p02TA5IwGZLrxPe+gnIYvzW3smFJWX5XE3djPR+cnLn/1F2XuslXZHxg=
X-Google-Smtp-Source: AGHT+IEG9FNaDeP2UFIyjK3kbzcSoVfRz+Iv7sLoxxZZniO1QKG6v0Da6WND3QnX4ALYHEemdnZ83SbSHvUGOHfu/3betk2JYWeM
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2184:b0:431:d3d3:4771 with SMTP id
 e9e14a558f8ab-431eb623d7fmr91264515ab.7.1761398943060; Sat, 25 Oct 2025
 06:29:03 -0700 (PDT)
Date: Sat, 25 Oct 2025 06:29:03 -0700
In-Reply-To: <eycmv6nwd6yvi4y2xlvqsjfzzoq46tlmqhbdu3bxi7rxfyreov@m2liixvk4ugn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fcd09f.050a0220.346f24.02b4.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in raw_ioctl
From: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	krishnagopi487@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E8BA01A000A
X-Stat-Signature: xjnhoxxccycnoebmnhpg7ipszj89y77o
X-Rspam-User: 
X-HE-Tag: 1761398943-255323
X-HE-Meta: U2FsdGVkX1/xh5Jv1EAt2V6jzJiJLL8LrXWy3bUNVGVtXFYDDLusfRpr47DbtKSOsowtEC3R+rRJQ6bdXxM2ZmiXh1FxMMMusQ8APTzm2A7F0wTAE70ov6EEwZmYUfTbeZWW4asWwIb3T3EBeJ99eh58bK/RsUXVvmaSQyYmKFHsgLGlr0Mu9U9R2nMTtCxaAhj5iusAcvMS6qKKrpltFyyXdjBKye3m4QYQ6fTPboO/Pp82pp6Il5XY8/iZ1TIwinTrmiJm78yFDlnfhnLz07B7/7qcH08DH29Za3RKhQwSm1n2L6hZsE8BCBaMW85Hpg7nsTzxw16T/hfc26JQ9F766HP0u0oWnJyyM5TLSvp+FZJCXvNHSH7T9A00SMD2PlSM0FBvVs7+MQVABaGUuOR48Cpb+ia/JwdlNINRAD1WaMXjxqB1oWt5SGSimkA8CugjaSwrh4O4i2/SXaEu0/6xH75zk6yGagEOvV9/GIuqV2kjqgxQX9XIyjAKg/vp/ql/wsMJoqjCJOPzfTjPhodf16blIFNUiAEevyKSdmksk+zgyKcT8BJA0wAlh9EPp1aPypmYHIghz4fEQzZgSP8lshTA0KqWicI3MkgIJ6ZkhbN+N2qvDT+37MFTYZufq2mKSPBnmjSL7N6CRF0op8P7cB/p0zxgoQ9EKN8xbFzLwpkT2423Z6S9iXQaESX3DZQEq5AFzM06TkMghqUcpzhH1rha9/9kDNTHhQqTUkPqc3nTf/cXfmRrUtfQWlIrY9nW0k/aLOCDn81adoJJVo9QAEkkP9lwd5HT/QhMDfIaK90huMfyTYlzkO3DGsfoxoUv8c4VS58ewHJO1ZxijjvXQQnRvhZK+Pd5qaJsQa/mGne4Ae3Yj9bYq/4CAC6pop1zSsnOG7If4kBTyerV9BHCgXpX0DxFEDDeHjpKP8WjR2+wm39YY0YKDSadBEllKko48pbwEPX3gHZyPow
 /8x1vN9P
 W4TxMq3S6SumGgjUjF/1M19R6sE2JcnTef5++f9RPGfJcS4KUPftj2tpKOij7B8AShmfinLlfGz8kUG3N7xWlbqjFEpDqnTb8eHPtKdaehU7fUHzXHsjgbVZTLUATYq4G7bgVkFseRkXk7C8oqqtIlVD0ZX6Dtn3fMSonXSqEq5AXmEEogY3gZXgn2AahMTd/5nPprjbSL/vbx/pl/mGfYZTizM1HvgoYuSy1xvxBJZVhfr0sLdlh5SJdB2r5SiaLKlDCOgNbFhvNZ7Cj0tCRDmNK9NjbWXSVhUUPf6fCTnavmqkwtVPH67NBrnEyVzMDjMPlQDtPDJZBexWDw+OQ0TPqKuk0iFEuYRTS98u5iL0lOyw85VMJFdDLDeaulBSHrcl9MMSkV/8SD21XHypQ919T6rcW1vSJF8da7rKFgkYUkw2X9s6fzhWqi8NvoVECWF8/ig4RrMmY5KqqEumM44cUv6lsvIm+G+AIDHYOlooibmub95jKZpwxTLgCdvOBortCswjDdVgqCl/rjEbEyCRBqDKVW5+1EGonL/uYZWVz6u3OqM/MvFf07zf4GavXLwdSxe2AR41pPbHeqyObvQ4bEHKnBeT8TYCvDT6jZzQb7W0maPwaj1RgEWxnHm1Y6uHeLkI8Bu+LJRF0e0OTML+6jHc+odsqJS1qcqvb3uYslNxlv6o/3/Ixl+L7oOBEUrBMHaHuXuwgnOF8+3YsZIGvs6QCd7zQRriWWN5LOqj+eNcx/N6nvhz5GW5I9Mdc6XNDhRbULvDqiFk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file drivers/usb/gadget/legacy/raw_gadget.c
checking file include/uapi/linux/usb/raw_gadget.h
patch: **** unexpected end of file in patch



Tested on:

commit:         72fb0170 Add linux-next specific files for 20251024
git tree:       linux-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=e812d103f45aa955
dashboard link: https://syzkaller.appspot.com/bug?extid=d8fd35fa6177afa8c92b
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1386c258580000



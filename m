Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D8FCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 19:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815C38E0002; Thu,  2 Oct 2025 15:09:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EDB08E0001; Thu,  2 Oct 2025 15:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A048E0002; Thu,  2 Oct 2025 15:09:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6310A8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 15:09:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F1EBC1A0617
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 19:09:06 +0000 (UTC)
X-FDA: 83954111892.24.EEACF83
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by imf22.hostedemail.com (Postfix) with ESMTP id 719C9C0011
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 19:09:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of 30M3eaAkbADUjpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=30M3eaAkbADUjpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759432145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Mv108VANLlPT1BaDVn6iMwG6M8LmHtYm3+Fi//cthvI=;
	b=sT4g4MaqNOwvCdV28S93Ua0zA0Ql20sjQORfY8un4g0gAYiuqwbTy0/8PK+pTkdA6um8xx
	nA21YW5qhxUiJou+GQLPhvA/Cp0/Y1Mtb9CKoQ31cm+CpRiTr6668/uY0mlk1IB0nZZJBQ
	IcDd7uzlNROl/Xp0Q9JkHBp+TaZz1go=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759432145; a=rsa-sha256;
	cv=none;
	b=bU3jmZ0NnTs8cTWprgUTU3k8tyhtfoD1xK9ofEA+hVsl0yZT+j2ZgoNBmCrFyuWMKkNnK4
	2DVFZkpbem4QGtQQpbLvM/HvgRPK/m1tcMYnM7AeQS8YA5cr5zh1y6qbc/UucPPfgW4rQ9
	hxU62bdQQcA9rA67R3epNXv2GxeMSbs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of 30M3eaAkbADUjpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=30M3eaAkbADUjpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-426d38c1e8fso14484995ab.0
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 12:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759432144; x=1760036944;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mv108VANLlPT1BaDVn6iMwG6M8LmHtYm3+Fi//cthvI=;
        b=QzlboLn2OWyVkM8NDdluOYRSllbrGTFzDBXddXXhfRXwkfQe7cn9CnEFmCZvxg0qSg
         0J60CashuOlD+tFAd3gBNxRiXn6grG24zgF7GCkfoLrTjCRmEyhblBkIZyGrW4fCKGU1
         0wThU3vRDo2za56wUc493TWW6lxRykHqeIfq6NFEheZs1FdCtLlDhTq++HJuDfomRXsb
         avT4PAt+l90PRniGl2xjA+3pfMq0Ms2p/KIZYTHnq7VMcBrS0s2QF7yyAb+lHVNkq7xl
         /PqFVTDwZP6rxx1tuffoSBCjIl6Q27WgEa8JqjPup4dZ0peMoM5B5Wkkfc/hK3qArV7L
         Jxnw==
X-Forwarded-Encrypted: i=1; AJvYcCUCmI45lXqgScyloCMJq8j8KzJ+3TLc4YTtwh7malntaokxqSERNHQzUqMF0/ccRBs8XevyL2DK6g==@kvack.org
X-Gm-Message-State: AOJu0YzmrBOEalRXxPFdft8iwhPwfA5XEw8PTusQPlRqUytR4awQytCe
	M4Oe1YvaK2Bm9pjIOB980AOLXkz+eQkbksSVwkRYPmN9FMPi6OOGs06odX7JEe9fYMzAOiyD88p
	qJLnXC+TFSGgwdunJG88rPe+ig5G+pHMnjsc5xMtwh0bxy07ApMuvPAqKv+g=
X-Google-Smtp-Source: AGHT+IEqUxiuRjUPjQxHv0+dxV+ujr33TW67ndKmMql+Cj2y7JXY4Lyw5bYlnDZJZpR+yp8/0DgomTfdR+IT595zFdQ1SdUEbr04
MIME-Version: 1.0
X-Received: by 2002:a92:cd8d:0:b0:42d:84b3:ac43 with SMTP id
 e9e14a558f8ab-42e7ad049fbmr6988885ab.2.1759432144562; Thu, 02 Oct 2025
 12:09:04 -0700 (PDT)
Date: Thu, 02 Oct 2025 12:09:04 -0700
In-Reply-To: <D66CC340-262F-4CBD-A64A-FC3D809716B7@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68decdd0.050a0220.1696c6.0033.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
From: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, jane.chu@oracle.com, 
	kernel@pankajraghav.com, linmiaohe@huawei.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mcgrof@kernel.org, nao.horiguchi@gmail.com, 
	syzkaller-bugs@googlegroups.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 719C9C0011
X-Stat-Signature: s9h8qyjc6y4gkmd8pjfpzogjrqwezb7t
X-Rspam-User: 
X-HE-Tag: 1759432145-794144
X-HE-Meta: U2FsdGVkX1/JtHX3MkSCr2vv4Qptg8cAHUsUAPQ40WVsJj2Ot876v7TQgabY+1aUDoP9PY0KRu+flOIyULAY11WbJElJrFoLz/NrytGByVOuzTCTCzmoR95oI8VlEf9Y5INSb/awVFP0IBGUeBmmZaxM+Bsguqeo5e9QU35hrnw48hrhMLcZPS02p8mQqUjBpogqTnIYl7qv+XhjOnae9vrUc89OmM9sfO7hayI4KwvI+TV/APYCAlZTy5H8zcAcIYk1CwvWH6GdkWCXAcOmxd7JhIirKLPiZ3qJcDTotXCEYGrmwUPWIfKgpZ+JDEg/9e7biKCHMV1OFsmZTWT9cTcoWAd/zCDU9nUOmS8NC2W3HWiIaja95ZnGru8OKEidywG0rlrhoNIWx1JfnVhwwsIMer25d6BxDv7rVpVBh9W78Itdqg6zTWxmyZfY08IHCKvpr2Su6yi0V7Z3BF/tdX75OBct7vzoY24ZMRiFnboXZk5p5EHH40a9DssV8igKEqrE+caWoEot7tExmxnsKJaNYj52ghAIl4z+01TT5xDgRWes5YQSu1ddAIX1ousMl0xOp1nzS72QIfZaa+iwKE1esrsz8KrNZvVwFpCXbX52xuwy9GxLjh6fdIPpWDDGXhIrMZrLhNCJ4xWB12evur1BMAS8c3e0DP5BmIj2HAEMDY3ab/T6pYB4dO6PaHP4o2HrxZowSP1JDCKkYTpmIGE0Aw9RsoUe7pcE5sBcT/Z60dPLYHpYzlq8JhcFa/FPHJrwwIt9LkKYqQE5coiyURNsZFs148fvz/srQxrscrFnCUUSP4hj9xjOEXEVasiwJK1nqL3apWr2dZbx9OyWd9QtukbRy1Kyn4aNGctak3I4cm0TINmCaDyBkWQ1qIMr8evna0EPYmhxglndW2El89LaY8VwA/uaDpw9/aujzHikJi8WjORGAPba3LCUs7/rQKVz9v0RLGOTlqOq3z6
 riSpfxJn
 Pb1Oi3MwzckVdKQNWADFySUB2OmpQfNLfbOk7G+fbeBwS5hGQ3T5dvGuMM+BjjGwT9K2FlcImWmasGf5XJqBc5jNGxP6+rQlr4Idyruykgyb+TkuTTBdK79lTdf0F5E/q1x8eFnP//hJPKlGqjka98OFB9fi9g3kv9TokZ8qkLQ53go1hRgrmySa8fbVGqWcdFSs8DrjLsWuKuQOIjurbRsSOYzaWe7v3dden6k1JjIK/bs7kTHIGpl2wsY9jpZj/w8iqQgysUE52XoYF4L+LYtu6wOjN6pntxKtAOPdx3O2y+cG9eTvy5z/8sZCEoJcYioOZAH3OvteaRnI3LEWkBMuzzXx7u4BYxdYFsXqa5mxJ9XIV9QsN4Rb/WkiYLcBlGo9ODcR0nclAqa6Wz98LTkn56SxQ8uaAxqalOvIjYGSbj5CjuXl07kxKMImUinRgvFdCz3yRxHOszitNe93Fil8RmkV6nCNfh+qkj20Ld8eZqk/d0Zl1LrvlaLb0GwDUUtNf6TuV4EhWOGfnNnQDnW8xlNBEMBlxeo1FKUM0BIrliKk44ka+wa3Qsg/BYBX5/1bxeJK8WXYb+Dm+ibmjWtIBFTRtRFYya9kBuhT6L/XnQjfrQChA/dZcGs5kJauEHa9fFejT2obGt0xo/6aDpz6+/B52/NK//6EdpFInyWketDI1nhOfnibMXg5xMsoVqP6B7mo68oH7GR6N+vWYXgUAmrFoZ6Eq05Qwrmm3mxsuOO2KiaV2pEn8oyx4vyUhPy6yCM+SB9D3UgM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
lost connection to test machine



Tested on:

commit:         3cb04835 mm/memory-failure: improve large block size f..
git tree:       https://github.com/x-y-z/linux-dev.git fix_split_page_min_order_and_opt_memory_failure_v2-for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1428cee2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=714d45b6135c308e
dashboard link: https://syzkaller.appspot.com/bug?extid=e6367ea2fdab6ed46056
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Note: no patches were applied.


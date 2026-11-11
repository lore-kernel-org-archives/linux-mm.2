Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E634C606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DupXvLyY
Received: by kanga.kvack.org (Postfix)
	id DE51E6B00EF; Wed, 11 Nov 2026 12:17:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95DD6B05B0; Wed, 11 Nov 2026 12:17:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85D86B05B1; Wed, 11 Nov 2026 12:17:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 988706B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:17:21 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D5D21A03BF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:17:21 +0000 (UTC)
X-FDA: 85423494282.14.1FCAA68
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 57683C000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:17:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DupXvLyY;
	spf=pass (imf28.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794417439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CHXsNJZUxPCo5A6HmwAJQBYdpTzsqa07OU0Prn+ncRc=;
	b=NRyNMUY1g+ZPNJPs6b7Gm86GS3bp6UOsGPISReOBfRB1sXVkc9wTc+PZ5sPKqGyj4dPlVn
	ZwjU/f9rRtmLi9DN6porZhJ2I0UvWpTT435v/wK3U0LNMDWaUs7NhqB9J9jlt9wBI+tvf3
	l1LN8BiU/jbp48jqHiw+1vHz9GwHHh8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794417439;
	b=ugcfIK/68ufN33IyPeBDCmWdMY5C2wjC7ft4iWvzGfTpZXMMcJFLAP6r/y2BIo4Jjr6ZzY
	FJAWg2dQLMCpj7dl0G7X0r/YsjcSXDD7kF5ZTiEDSMcUpw/2MDtp/XFhITNv241MbQYX2X
	zAXacYwqt+xJm5/oPYtAHYVlIXg17jM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DupXvLyY;
	spf=pass (imf28.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-91e98301805so33478716d6.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:17:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794417438; cv=none;
        d=google.com; s=arc-20260327;
        b=ZBArpYlNa5ucwgL4uRdjC84t6IVS++OUHnGecyiEA/0gLOldrbK7L8/M+eBqqcR7G+
         xJ2Lg7OO9V3i8szHgTkmQ72JmCfYaaIEQGNtK5xapOgLp/XyGVSac3sEfSjAPfWrjpEg
         9126DNaaocRL87Rut5KGAAAcA04D93O6hI5o5hFykCRhblCO2OrjbgUTNHeAwGnMJnxb
         UKdafR6LZlHbqTFIkHskWyk9EG7gNMNoSVuU5g2AkUDLbGfzVOSB3eXTAJiW09rI6lVw
         3Memp940cTzHN6k5hHakLaiPfRjinSqtAPeKBoscQN1TUK7ULTMmI7/ep5dSEqZTnlRR
         2FOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=CHXsNJZUxPCo5A6HmwAJQBYdpTzsqa07OU0Prn+ncRc=;
        fh=oq3PpVWMPfltEv1Lu9tk9H/5rYXiuB8s3Xh8YH/mo3w=;
        b=Ecxgxv1Wd8BQJRdzn7vPkuUc8wME1AAQFp9kwXEqDiWnbM6vJP4isVWqFeHGfr3cjg
         MhGLx4Pzh/yK7EQ13gX6bg1hR9Dizn5+0N0IHM3V+h3VZk1GSD9bLDx5RfD1+jvhGLz+
         1UWZKc5Aq+mBLEK6rpRTkJPCZoTLk0h2bZ8RcvWecOcT7wyMy6CEEE8tnG8RpinGKJSp
         cK1pAj80X9tLKu/1pZmyOCF1/LYB7x8r32ltJkC6xHRelKhhF4RverraR6rqECThQhTK
         nwAPNzA2K91dwDf7WuJXy6hl/G02hsjWoa9VFUeE2BSpH8KNFEnAvBevtlwBsuV0/UNx
         VrGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794417438; x=1795022238; darn=kvack.org;
        h=content-type:to:subject:message-id:date:mime-version:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=CHXsNJZUxPCo5A6HmwAJQBYdpTzsqa07OU0Prn+ncRc=;
        b=DupXvLyYdfrMsZ0KlqW1FHfR3+z2SyooSBpUtzgXjIEaL80BKQAAntn78EOfUFAV0D
         1J+bDHxuJkSzGlts8Vj0WrDMhweI+D/+b2BQ10h1X6iZcaWtn9gYR4D7JKON1yfFOyed
         EDYUMYTs5/z8oBrHp6LN1KLvq5Jox3VmG2PbwIWYqKY/FCR02GZwUXGl58kq0X/MjV9u
         ila8htbmmpVMjYVgItkZbumilY3YWn/fCh3Jeq3TjcCattFJ8761zA4+TpGJjKdYo4kt
         vBHD8bohcYsWa7pkDIFCurK67cH6MNDbV8kWf4nIrnpnY5MvOeGGl+a6VM4UMnv1pbKV
         FE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794417438; x=1795022238;
        h=content-type:to:subject:message-id:date:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CHXsNJZUxPCo5A6HmwAJQBYdpTzsqa07OU0Prn+ncRc=;
        b=Z8SFm221WBJWY1hHY03KMik99C1l+7Xl4f5jl0B19eiuzlqUoAX4oikro/ialPCz/p
         Pl3FJlylORN58dqEsd6fli68owwar4VY1Vrbs91rC/QI4HrGeLgW5ZU5ZpDKA8eo86ng
         G5xQRNANjp2cvp/HBWAg6SPmXfyzF06WABAcgnzX/w7e0eW8qlqj3xOrxaX3+YrGfzEV
         39GnTILxX+CyAvoih2uZuvMwF7wzIRj88aX1DG62HVwLUVtA0+ogzPY8Ir6r65xxRogm
         P36mAaKAeaFsxO1wx6+5BExgHgDbGRSfBRU6zZrjYmnpcERqu13vZ5vVxJDzL51zDf4F
         TmGA==
X-Forwarded-Encrypted: i=1; AL+hErHqGr6NSJhM2L8EG1FU+mulU/OEHnQx86dSoXBypjF6cgGyYa9zoL91ZHVAu49DdlUiS0jWoZXS2w==@kvack.org
X-Gm-Message-State: APuU4Z9Ssctu9e/Q/H4jirP0vYWY2RJjQPAqZXOUl9UkygKzdOHAZl6a
	FL0IantbFwMOqwhgGN6cAV7zKePlSOheC24cochatS2qLynD+S0KiOSGxTzTfn1n4dOw+sWp1Gx
	pXg8DuBt10tVN2SNeSWgmoyo+Q+L3FcRipkAlxVKL
X-Gm-Gg: AYBFou3qCV7zfhskeSKd7Ky1AkqJ9L2JUBzVv3YLFLtrxQScUbPMXjCZE9UO4T1ZkJx
	G18laE3NE3EyQv3LGofNJJ/EyN/zJBOzTfPr9ab2LALNb3kDOSTHQq8JkO/GyVgCKmTekkpjl+L
	HuaJTgo6WnQhW70KM+OwLhXbqzDNYscpliBmnkN2d9aB9yBvXphViXAWAU/8xYmxVQxeRLdaNIV
	r1DjE1l9vhP9dStdsZGCrwiZKu5QDAIL578SwafWHZ95Oef89jU5oLQCwkJ5ID3Cw9OnBvJZ60E
	EqDaAh/tJ6Vkl1jQdShJ26N5/g97z8Jc4WlRfnsOe+wUi43XiglRNslXoFEK+nCMdPTFb0950mh
	+c+ZQ/bfRgNl6fc+64urCEyi3hRhbc2IqH4tv3qTwL27ONRVYSBgWBmS5iy4d0k4s8JJ4om/tzT
	FdlLlJz2YUeoBDDo5vLw5hPpVX+c/QEg/e+5h6gc/doKuAI4fS
X-Received: by 2002:a05:6214:2c10:b0:91e:eeeb:5ab9 with SMTP id
 6a1803df08f44-91f03f95987mr55271816d6.16.1794417436892; Wed, 11 Nov 2026
 09:17:16 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 11 Nov 2026 09:17:16 -0800
From: Ackerley Tng <ackerleytng@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 11 Nov 2026 09:17:16 -0800
X-Gm-Features: AclHuK-JW-dz-s3WPckdlk--4-Q2gCEfYsudv4IbzOOLXO2CTOfiTXaBjvjq8wg
Message-ID: <CAEvNRgHLXryXj57HttDu+ZD6ogS3oRo0A360F0Bt9V1Fu=Rt0Q@mail.gmail.com>
Subject: [Cancelled] bi-weekly guest_memfd upstream call on 2026-11-12
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: mg59gr1spj9ehwtsgo5k4n8r8mskqfhr
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 57683C000A
X-Rspam-User: 
X-HE-Tag: 1794417439-963599
X-HE-Meta: U2FsdGVkX1+PVAIg6bqgy4Nm1cZtWwe2cEcFn14NDDLgSOwi7UMAF6On9nlubcIL7tWevT+nMq5UVR0ESGK9HwTpFRTCB81yw8Mia+hgEJlWfSQCP7zHSmjJhbucaA0WBaWQlv4BiurUlhqoawZ+NjqN0HfguXHKkvrzrzoAG6525FGeC9peryVVicjmovY49V2ox5GD1PVpD1cfC09aBBEpbCUMMO9l9qOJrW/FUP+CL7SW+KFwRoJ9DR4Fgy/TFjo95/jF+LHlZZSK9zGD6Cky6jZ8mc3prp7s8AcT7+1AZNlT1HWOGJv5GDrtapEg63txDZNuRIMywn9mc6wymooQYlYCukTuwi4+xQvmKGtQ+3Xwm2UrUyuGC9CT1joQa2ZrgIIWoGOM5wvY96M9iUjNwzvjXpSdsXwMAFJAfJ5Yj94GM9dIC2oKYSsnySibt7oADdKBJehZ1qMeUtUfw3tXE5pEKUsxQWM9HStqpsxHTMOv1inq5sCyp0zIWSBKeE/prsBC90ZFvm2WIBc2rtNVMLfR90LSDUBz5z7WL9ryF8LRoxmKRmcr4mp85NKfRRbtvYyexFcFL/H+EslqCoY4kkP5bwAKeiSg4pUx8ndIJQm3r+B4hdrar3xVXRBk6Wz7XDhehTo0qg7Zj2O2hATPX6JCl/UeT1Qv7cEIlC4H33kl2JgyiBEvBf6XziTsT9kypEk+05So6D5uUmunXHGxLTMe0JmDj86aNRW8evZRdl3HeSdSsKoBRaUrmh0X8JOANPPwZMwIhLk+VRuojzOFckA/Op9R9ImZrUvb+PW5zu/M/HxAy6YUY1FZnb4gGddlZgUI5DavWfjX6a0QrbdvrriOuWCWH5Rz3dy4WNG1rdY9VxNIA65RsZu2kLu7lPSsuzFeRYAMxkV3mPTbCOXxa31GkIPdvu1kmVylkwWCz9tJyPOvQ53UwSKzQNvtoTOo0trpZXwDslFWpCm
 rmr8zHxR
 1cv6Ypswqa3UzedqTboJHU2w696mXAqW3d5CUsA6PQYSuFkUxIR/B19GgGUd0+fJFu7Mvsz3Yn/zCmgY1t1s6MywZTDRvyqlCFw9S36P9QKNdr2dxBBJERfThBtLHdvJKHYiP8eSkvXnju76RdZitAx7vvIs4CzzCasa0qlJdr9R/zx0+tL9nxDLEAuC09so8pcrQQqf3cykICjyAsyA/bY9kkK2FOj/jiPzkyE1lGIiRr622E84sYe2O0ZhgvhlNqQWE+AmPtccXtsy0qYkYIe6F5yM2eB3B5ORuPgaMtBTsg0QX0/per3gwNOUOyFe67hhNRr5jEV047O4TjeL8H+oZCUo2KdM9DilD/c9TNsz03W1tRPsSWlaMJWJddjoKTojofLgCOixAvS05zMhTs4ra6MqQQp+oQizhex+ooW0Ja990MykKtD8Szwn5QzUc3ue3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Tomorrow's guest_memfd upstream call will be cancelled in favor of KVM
Forum :) See y'all at KVM forum or in 2 weeks!

---

The meeting notes can still be found at [1], where we also link
recordings and collect current guest_memfd upstream proposals. If you
want an google calendar invitation that also covers all future meetings,
just write Ackerley or David a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

Thanks,

Ackerley


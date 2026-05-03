Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 075BCFF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 07:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 300AC6B0005; Sun,  3 May 2026 03:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1A06B008A; Sun,  3 May 2026 03:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7C66B008C; Sun,  3 May 2026 03:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07E846B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 03:27:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 906F2C2A54
	for <linux-mm@kvack.org>; Sun,  3 May 2026 07:27:03 +0000 (UTC)
X-FDA: 84725277126.04.7B94018
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf19.hostedemail.com (Postfix) with ESMTP id E62AD1A0002
	for <linux-mm@kvack.org>; Sun,  3 May 2026 07:27:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of 3xfj2aQkbAOgcijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3xfj2aQkbAOgcijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777793222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=4+osliUaymIVFH6R5/bEjn0M5p7u7//4ClVsL93EMMI=;
	b=02qG2YPhd6Mf9N3HHItPUuMV1RXiVaaCLVE/uR/7+PKRbCx6IGht8AmzW9XlJlSEWUJjcT
	qfFjv4H+R/20cmzlTq8LemP7LzrPurB6yY0roSZ+v27hKo5bfPbIkH5eBv23atZ/FQS34W
	ED/ZdRLYtlEqYTE5nXd7iByWbN7Hb/4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of 3xfj2aQkbAOgcijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3xfj2aQkbAOgcijUKVVObKZZSN.QYYQVOecObMYXdOXd.MYW@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777793222; a=rsa-sha256;
	cv=none;
	b=Rh4qi8D1gFz2r3pjlYQPCIKMmHsBqiL8xqIZXtNwZ10bt0SJHnhLS2Z0WM4L+Yo/wWRcGu
	LO1BEkJ/hA2S6kWDX/lgju4rGj/kdbkhz6SYGoL3VhhlQkfNjV6fK79uywipTXZcceFPX6
	CoIZOIFhzafEPqwkD4G38BMNXpFp4Xk=
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7dce1e67fccso4926688a34.2
        for <linux-mm@kvack.org>; Sun, 03 May 2026 00:27:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777793221; x=1778398021;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4+osliUaymIVFH6R5/bEjn0M5p7u7//4ClVsL93EMMI=;
        b=Gv+ofEF6sNuwfLmQTm00XpCDkRmQ9ThriD8BQj8zsMVNmVjVagx6xcbL4F1I2FM8gG
         FZCAr/mGcjxnB5igShWAqQEPGZjordId0COsK1ryVGfKx/PFt31UfoVkaRRUx5f8Gg3f
         15RrkpqeZS3SZiwAOzsYVv11QOVaHSGCY5lbata2l3kdEn8iRBRw1gpzRxHe0WssbgSX
         o1KJzONKPipfqOVXSoFLGbS45ksL8fi+mJfyL17WxJnSlzeeVrhO7vwufysYtmqBh4ON
         P7kgzdVZImQX1Ws8KcxNI8sKGgvS6AwhxqPCs6tFRX4GebassFWc1x1XpmvaOCos94IC
         JVrA==
X-Forwarded-Encrypted: i=1; AFNElJ+f3fFAx780EvFcMDbNZB/8F/NaUnB5HpjTKrDP8nPl2GA13dWnQfB8GHeJSTeUn9vHB433jMztzA==@kvack.org
X-Gm-Message-State: AOJu0Yw+olAV98tjZvDLNyGAx6XgM92f31YTTENgtTUAXmDyq+pYHnkr
	U9LDix1SExCNrw5XcqW9eJBiQWtdWQxjiZytdmr/wLxLgzwr//s/7/0hLcgUNJ5EzQVHB0UZT/s
	TG5/F0JHehi3XtQcMryTZoUtX9mtL6ZqfbHnQOb27pmvec9MUGxkYcS157V8=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1626:b0:695:94b4:d4e2 with SMTP id
 006d021491bc7-696979a4e5amr2197059eaf.5.1777793221036; Sun, 03 May 2026
 00:27:01 -0700 (PDT)
Date: Sun, 03 May 2026 00:27:01 -0700
In-Reply-To: <e50ceb6c-4239-4009-9578-51ece89fdc77@dev.snart.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f6f8c5.050a0220.1584b9.0044.GAE@google.com>
Subject: Re: [syzbot] [mm?] [exfat?] [f2fs?] memory leak in __kfree_rcu_sheaf
From: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
To: dxdt@dev.snart.me, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bytdmr1h44x7co3umpkns4h13ut8ze5e
X-Rspamd-Queue-Id: E62AD1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777793221-752765
X-HE-Meta: U2FsdGVkX1+xH+VrVuL2eGkxmy4WyhSW+JPdDtqBtjDMfceaXASFf4pcTkTw1lMBiw/sT8269quPttKRjwpgz3GrnX5xNR/grH9bNA2N9NPNFwAT7Feya0NDFEqoawd4/zcBsXrsazpvGXpKU+WAtga3fKKVjWgCpbxh2NMkbC/k9Z7K3+9fpzlc3aD51mUzCJHqc1FDKOuXgfork7SsiIzFPK0h4JWz8rwqzzNYuvw6sFomVXY8bISB39rzdD8nvI+a0a9XPM5saSqUV4G1/59pRh/27gkdAqHbhM7+vA+A+h9x1G6/ii9MOZP7FPSvFchiYfs9yFB6qqLRN21e8Fm1amKu9j95pHffGjTESFV24mEv4xHDssPv+b+GoeuAkAjoLdvBzcqcbU6HbKN02tJ/9TGIQv6nLS9/ysWty5Y0hj2tQUfZG9FfKL7YAzIyjaPs2EB/hR2jC5YeJ3UXkEBw4LUjZeUx7qTrjKu7t/psWIMPrjlEkr5wSEpUXy1qL1VtgySxoU9bW61HhqtMn5RzTKss17PKzSK3xK7zrIgQnA8YFyC6+lB4RWqq1lVU7UOTLQzIaVri5UIVkag4ji0IS94WP+77uykHo3xqQkhr7TL//XdAuqi3AVlvtyYZC99QihhuJc5asRnmDvxv/PwLwa5QEizzrDOJ8dM417ZViStiOAsUIZ69b6/SI/FLbSPzOQKeVrWQRyI4S+2iKBJN0M2Hj40t7DVcHDgsekya0WC6YffNoBP3f4VybvKYeFrIWmJXuBNwrzntqNXrG3No+97VQQ/sAzqLUq6NuvmbMKiq3Sn3VBox0DWFeBgPxdKmrIIQVhV3o+fxfluh5ssO+rVNLgVuJcBlJoBL1EqpOSoajrrYx8CKheFHveqW0EEuT7k6W583O9/1grgnbFQpD4n9+bmOn36g13FaLdwVzaUbmG9CWI9ThHdehSQ6lzUAVp+BNe/dcV+kAZA
 +tCHpUGu
 PSrBOQe4WKoDcrECXfrTBAro0Ub64mSKvFFUjX0ck55KPWCzIS7RNWI1UjDODejnccX6bM9Erv2110CdPRGk29UmdIHdy/QAZqV6dFH0j4ZSp94jIjditvA1EadaUrGRk3C2WAgISeUDQotJU+bvV9RcW0Niqg+cv2+KsclZN2SkCxjM9aIDAu21PiYTRYqkNxPCBYhV047IIO2W5SGeuCJujKLffy+CTJJVnBu9lPR0X2qXCSGaqqJeuMDD29GXfjoStGxDINkMfJmisgqrASvrPf+sFsaGyn1Pkx8X2MlLUWG2ZGs8UIfVYPHnSEL/PXG8zc17gMdolR2z1AhxqPHjrA8rv/nGGHVNn3JatvZK3DxEz3jpKRgTTCN7a1o8iEpg8JVD1uA6Yo2yNQH1yuuEg8pB+6YvAEJqMUsul467QcGXvsbDlMbNuGBEoT2p6f4NHjOL/xm5JdZKhiDjor6Y4x8zboSpK82as0W7ghCclE5SBTt9YJ5oxzHjF5VNdLBzdwiSKxPwEY8clrrLvTr5jgm15rq+ygTl5sEz5bySdf0I/TBC3YABzr1uDW4U7M0+M6p/8ItnBaNRIi9Ge+OtI9oX2NWzbzLO7MJm/DDXKrHF63RkPV3Vhkjw0jQiZ7q++2bynskGufhXuLgviSf9kIPH53h+/KalAFPtcfry5fXV1ptz2tDPLh9hhRVjS6OKeHz8ZE972CuaLcsrRug3BKXG27z54P73rprWcgMX3etJTzALGLQKx/k01Uud8gvLo8DqzTHg0wKlA0obm4gYWvSJA1K1MZZ6oRHKTbl/MmJj6rSuPGtdT/iIUKfl37A+JiEzGZXdX0NoOumotOEHGpct5snGUhbdBG/Wieu1pmWf88Tmo5AdEUZMeXxjVM5Xbs2BXqxp9ZTO9vhJMYWtZVTqOu/Ur7/Wd/9z/zQy6WKkiZ54NeqYypqICXlxdG8/F/p3+Hik0maH4j9oQQEZmXahC
 XBL5ug1L
 Q8M9kB2CrAXxEJK6rtLcorigtzH+u0DH5pStM9i7F5srTcrwZZGw1G4o2gOfp4uSUnie95iEqvFZ609cSJTa/SO2JwL3Sq2l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com
Tested-by: syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com

Tested on:

commit:         66edb901 Merge tag 'v7.1-p3' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11fb7082580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9645c21cfd1d3e8f
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17f2f326580000

Note: testing is done by a robot and is best-effort only.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1777DCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 11:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F18A8E0006; Tue, 11 Nov 2025 06:02:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A7438E0002; Tue, 11 Nov 2025 06:02:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590E28E0006; Tue, 11 Nov 2025 06:02:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5E18E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:02:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4AFFC0504
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:02:05 +0000 (UTC)
X-FDA: 84098036610.16.2BE2C4E
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	by imf04.hostedemail.com (Postfix) with ESMTP id F393E40012
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:02:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of 3qxcTaQkbAHYmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.72 as permitted sender) smtp.mailfrom=3qxcTaQkbAHYmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762858924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=+sc5Korg4AeoqU0s5Fw2spKKbv5zLv8ORI3OPdKe6uo=;
	b=j4WvsF+M48mIeFLCYgK35jWFk+uGab/WdeWsQym+C+boXDxDvVIQkIAt1LzsWtwjz5vxkJ
	bGdhSJmqAr2dN2m1pKaU3tB0Oz7Owr5NsqkC5DgDcJw3llhn2bz/PtdfLoyc2fz8dcaLDN
	gViOsjbsliubx62E62dwvLfd41nxPjs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of 3qxcTaQkbAHYmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.72 as permitted sender) smtp.mailfrom=3qxcTaQkbAHYmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762858924; a=rsa-sha256;
	cv=none;
	b=mTjerYHrrntZUXZYiTC2evsvQXFgVSySgj0mAdY7RjAnsh/9zoP9Nl89fq/a3ccEnJoSKO
	E4DcrO80ou9Bn2SabfWGr8b9C0s9b+T8Pxr+d7K25wTBGAVOGp2YJLrqVRD7saUjPM2cdO
	On9WfopmHAD58zLc1yOpm5RAe1Dtor0=
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-9489c73d908so240264039f.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:02:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762858923; x=1763463723;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+sc5Korg4AeoqU0s5Fw2spKKbv5zLv8ORI3OPdKe6uo=;
        b=QGd88K+H9HbrqFXH58D5HSJch+VVAKkGquCdbW87lDCwqHbGh9kDqo6gd4bmZpy6V/
         8Xt1TiAgourpVaqtqTBjxuXNAJB5Orv4aY6P5/Cn4OkDZ9laROQb7br2JpVKnmTWQSOz
         WGcqfJoUNf7fW/I4NvtUSuIm8hCSt0+s4LBjS+fQPnWp2MVwOE1zVeAMzR1K/s3Q2Ywp
         VXmcfDQwkzfbxTiseuouk8/vlAvpHkVdKkGauw8Lq3CVW4Wlb852COJA+Lj9aKqMRZII
         NZcDFFvd7WUeOMml1uFV/sUAHu66wxs3NbzsjQU/3jtzgWREQRtqUwAp6Fq2MT0kMuV7
         Lkmw==
X-Forwarded-Encrypted: i=1; AJvYcCWgZptk02vOjQxZS/Sl9+qZcaUW0DOsSVy7hkJdWPgtPmctHMnT5ZRrBULX/S2Gp7CHIqRTEmZTnw==@kvack.org
X-Gm-Message-State: AOJu0YwgcnGQhYM0l/5Nf8RLONNifzUwQF3VmrNvFUZcysmMEIUhjg2w
	XvgVZA4HX1JmjjNgY6WQHDZITDowaUCypdFTgM1/XBDOiXCu9zVp7uB7Ddn7AaD0qW173S317GK
	tlFwWVytOs0wnn710+Sctp8VZmwpfkp1+6U3/kPqpeywGxIREBsIeCpJEnmE=
X-Google-Smtp-Source: AGHT+IHBXZBrFdLIgyjkqvfIg4gI6jmA+raw0msokREm6gzLfpI+vebjMuP2WkaEvf5arCqGjEKDOXDu/EIdYaBd0UwInqtN5ON6
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b2b:b0:433:29c3:c4f6 with SMTP id
 e9e14a558f8ab-43367e46ac6mr167710345ab.15.1762858923047; Tue, 11 Nov 2025
 03:02:03 -0800 (PST)
Date: Tue, 11 Nov 2025 03:02:03 -0800
In-Reply-To: <20251111-anbraten-suggerieren-da8ca707af2c@brauner>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691317ab.a70a0220.22f260.0135.GAE@google.com>
Subject: Re: [syzbot] [fs?] WARNING in nsproxy_ns_active_put
From: syzbot <syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bpf@vger.kernel.org, brauner@kernel.org, 
	bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com, jack@suse.cz, 
	jsavitz@redhat.com, juri.lelli@redhat.com, kartikey406@gmail.com, 
	kees@kernel.org, liam.howlett@oracle.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, mjguzik@gmail.com, 
	oleg@redhat.com, paul@paul-moore.com, peterz@infradead.org, 
	rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, vincent.guittot@linaro.org, 
	viro@zeniv.linux.org.uk, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F393E40012
X-Stat-Signature: 1yj19s5fawj71yf6xntotcakymmea6e6
X-Rspam-User: 
X-HE-Tag: 1762858923-799782
X-HE-Meta: U2FsdGVkX19atYH/D0NKsOU6t6wktKRgGyYHZdFp3fJAKxEhfdSGPdMcHohfHU4IR1bV+oJXSJWRsubQa+1bqX9tU/g7FlIUhFn2tKWi55bgbaiGQaufPds/uM13TSNDJiEGbShoGP86jvieAcHBnM9e0qocBXaYljo9gBGOZksiqY3m1Jn/sSYeiPdE3uVYcQlGrTyaPFgbJR2T+jGUxndAYtDlcPlZ1OW8AgiVSbCURcxsS6rrp4AEca2LDuiTCvEVFrHvFTF4fPIEL32mkNBryTLZACEZIpQW/3DJnT9fz7yWfO6q7PG5blkzU1P+7ihAO5bSZycOhIa9kLThx6tLKI4Vq1Oxn5FWKzptyLCNvMnifdtUbZML0q4/mctEWhSNAKhRzo6FmCss6odxGBrtOkTFBNtHb4/OkjZXfrBPw93UgQ577fXblXdiEuk6sZ4TL7xiehl+VFX0udQvSnLQ0l2UKapHG80igiR1+ByxKcOfZ7UDFHFIPbnBkVBtZuwclxcVksbpHOh7lQhu6Fkddv4rBUCnsWi2azjqGKTuaEkg/dL8NwVgg6cRD3l6xD9OWMKgmwfXcvWmQNDlA5lcchLVg7TP0B4mINTqElgDY5TWHQA21H8kVqPLL88lvd2WBQB74fBQmuOT1+cLG3C6Fo94ZcNB6FXhmnns4Kwic84U/2Zk5p8gNIqdKlWEKRKXA97lr9N/Bh2Z0lpNtq3OsIElKRGivEFUpCkOY70pFiW69MSyy29G+EVh4/XomhQnjVmz2K32s8kVfLrXqDfnAtchW8mE0LhYQ+L+4CwU6ADzjTeluOTqlQ6TbQnBsx0uMgyRzRSc9E2XInKUW6RMlC42eb18uTWAS7562Odz2iqF9oYW3IAOaw8H1RwNR8S0ehakqc0bOGKuIkAqd2HJLMiHDWwbqBuFZR6BGJswJ5M9cFVE41jukGQd45MUMrXXoMeddHjFkewA5Mu
 afKN1zfK
 2v4U8Vx485R8yJgRQoUogyy7GotBhgTeT0E5+SA5/s3bnTpjIBRXgkc8h4RwTKI+5IjNc8iPiZ/45vww4PeuiWSYIciuXx+Cx6BdpTr2UGJr6u/2jH+HlQ/UsqlIKZL4NEYG/ws/Wv4HK6oQAtjaEQ0Fpm4Sm3f1GdCFbTP83bDyprNUBXOkVOXO6+KIQmrLHTSwrkPgNmb6pcdou6T8VnQaHnWsMU8+lJttWxwsk+E+a18NEGNo66zgmbUGD0upEBHBToKD2msystoieb/ib6Jr1fnaVKdqylN2wLxCl+/Y9V3xAZIRluby0e5YMZNMtOcirR5V4XNxDGVKcR6l9biyZUMJRSEqmiWO+xlQA3bGeJhfc9q7tmhmeFxAvhsfl7EDdAarjFYJkHLHa48ZJ8iAwVBl5XtWDdfrzYMUu4ubPdYm+ro/23JGIJi6ckTGydVrVLKcrw9ovAPIIdSFZA3kLWqlpGLWc9z5VtMArLK0GVZsB4BY+QRU+jeNrRA75/4Fr/Dc3wcQTfwTz8GSmnR6nqJGbKBmBxag9QvLksau3MOHm+1XMPy3ukGWLBKZz3lXCCrkWH+HrwfAkCfctV2j5JuZYSYBSpSFGnrdM/KIbMmWFcvUl5yJIbTg7DGhGAhw/UxFXlgAkao5uoT59GGFdYpPuXVYfTU4UBR7uVKKVqtKvYGn55Zg5O/8eq3oWk3ZYV5XnJLmMkmU9tdHnH80gqxrF7ANCReKvetRW0XLDMYe1E9HvQW7qa8LK+B+XkJyIOj/bCwPjUichCtelfaNbrR+vq96bHP13pBT9XOa2gxowyOYTg111lWaHiBs1E8LJNrZjRBjTF2tq7q+djUpnsmlAyumq1FYp/Goz/7lppAoGkUT2WnGhPZudqh0fZ0gFYvu6scsI7sKFV99IICEs0rpZ/FU2qmLSfrp0cuRdpFQGSHmRzmjg94ziS7zGOP7t7khn+J2tDTsm6BfvCVswnobx
 wclbgL/k
 /xk6IfoNVG+AkZOn8jRW6YNqoSqEHgi4iHT0jWY/m4IqZs0yluLh8FEBzfhp+JyyJ8mO2Z4xAm65kIwZjbLqFtENUA1x4PPcXvZuSdbr14pPvovhvEV1FRWzZbMnC6cC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

SYZFAIL: failed to recv rpc

SYZFAIL: failed to recv rpc


Warning: Permanently added '10.128.1.29' (ED25519) to the list of known hos=
ts.
2025/11/11 11:01:12 parsed 1 programs
[   92.366829][  T894] cfg80211: failed to load regulatory.db
[   94.101317][ T5831] cgroup: Unknown subsys name 'net'
[   94.208868][ T5831] cgroup: Unknown subsys name 'cpuset'
[   94.218695][ T5831] cgroup: Unknown subsys name 'rlimit'
Setting up swapspace version 1, size =3D 127995904 bytes
[   95.913996][ T5831] Adding 124996k swap on ./swap-file.  Priority:0 exte=
nts:1 across:124996k=20
[   99.210494][ T5845] soft_limit_in_bytes is deprecated and will be remove=
d. Please report your usecase to linux-mm@kvack.org if you depend on this f=
unctionality.
[   99.368014][   T52] Bluetooth: hci0: unexpected cc 0x0c03 length: 249 > =
1
[   99.376801][   T52] Bluetooth: hci0: unexpected cc 0x1003 length: 249 > =
9
[   99.385991][   T52] Bluetooth: hci0: unexpected cc 0x1001 length: 249 > =
9
[   99.394090][   T52] Bluetooth: hci0: unexpected cc 0x0c23 length: 249 > =
4
[   99.403295][   T52] Bluetooth: hci0: unexpected cc 0x0c38 length: 249 > =
2
[   99.760048][   T67] wlan0: Created IBSS using preconfigured BSSID 50:50:=
50:50:50:50
[   99.769465][   T67] wlan0: Creating new IBSS network, BSSID 50:50:50:50:=
50:50
[   99.812956][   T13] wlan1: Created IBSS using preconfigured BSSID 50:50:=
50:50:50:50
[   99.820978][   T13] wlan1: Creating new IBSS network, BSSID 50:50:50:50:=
50:50
[  101.094305][ T5880] chnl_net:caif_netlink_parms(): no params data found
[  101.244059][ T5880] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[  101.252746][ T5880] bridge0: port 1(bridge_slave_0) entered disabled sta=
te
[  101.261818][ T5880] bridge_slave_0: entered allmulticast mode
[  101.270392][ T5880] bridge_slave_0: entered promiscuous mode
[  101.283473][ T5880] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[  101.291198][ T5880] bridge0: port 2(bridge_slave_1) entered disabled sta=
te
[  101.298667][ T5880] bridge_slave_1: entered allmulticast mode
[  101.307108][ T5880] bridge_slave_1: entered promiscuous mode
[  101.360560][ T5880] bond0: (slave bond_slave_0): Enslaving as an active =
interface with an up link
[  101.373330][ T5880] bond0: (slave bond_slave_1): Enslaving as an active =
interface with an up link
[  101.413565][ T5880] team0: Port device team_slave_0 added
[  101.422832][ T5880] team0: Port device team_slave_1 added
[  101.463069][ T5880] batman_adv: batadv0: Adding interface: batadv_slave_=
0
[  101.470261][ T5880] batman_adv: batadv0: The MTU of interface batadv_sla=
ve_0 is too small (1500) to handle the transport of batman-adv packets. Pac=
kets going over this interface will be fragmented on layer2 which could imp=
act the performance. Setting the MTU to 1532 would solve the problem.
[  101.497282][ T5880] batman_adv: batadv0: Not using interface batadv_slav=
e_0 (retrying later): interface not active
[  101.511788][ T5880] batman_adv: batadv0: Adding interface: batadv_slave_=
1
[  101.518889][ T5880] batman_adv: batadv0: The MTU of interface batadv_sla=
ve_1 is too small (1500) to handle the transport of batman-adv packets. Pac=
kets going over this interface will be fragmented on layer2 which could imp=
act the performance. Setting the MTU to 1532 would solve the problem.
[  101.545058][ T5880] batman_adv: batadv0: Not using interface batadv_slav=
e_1 (retrying later): interface not active
[  101.590841][ T5880] hsr_slave_0: entered promiscuous mode
[  101.597434][ T5880] hsr_slave_1: entered promiscuous mode
[  101.741572][ T5880] netdevsim netdevsim0 netdevsim0: renamed from eth0
[  101.754163][ T5880] netdevsim netdevsim0 netdevsim1: renamed from eth1
[  101.764799][ T5880] netdevsim netdevsim0 netdevsim2: renamed from eth2
[  101.774770][ T5880] netdevsim netdevsim0 netdevsim3: renamed from eth3
[  101.805511][ T5880] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[  101.812788][ T5880] bridge0: port 2(bridge_slave_1) entered forwarding s=
tate
[  101.820983][ T5880] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[  101.828371][ T5880] bridge0: port 1(bridge_slave_0) entered forwarding s=
tate
[  101.843110][   T13] bridge0: port 1(bridge_slave_0) entered disabled sta=
te
[  101.851795][   T13] bridge0: port 2(bridge_slave_1) entered disabled sta=
te
[  101.904027][ T5880] 8021q: adding VLAN 0 to HW filter on device bond0
[  101.928006][ T5880] 8021q: adding VLAN 0 to HW filter on device team0
[  101.942529][ T3448] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[  101.950392][ T3448] bridge0: port 1(bridge_slave_0) entered forwarding s=
tate
[  101.964563][   T13] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[  101.971799][   T13] bridge0: port 2(bridge_slave_1) entered forwarding s=
tate
[  102.152983][ T5880] 8021q: adding VLAN 0 to HW filter on device batadv0
[  102.197805][ T5880] veth0_vlan: entered promiscuous mode
[  102.210102][ T5880] veth1_vlan: entered promiscuous mode
[  102.244663][ T5880] veth0_macvtap: entered promiscuous mode
[  102.254634][ T5880] veth1_macvtap: entered promiscuous mode
[  102.273656][ T5880] batman_adv: batadv0: Interface activated: batadv_sla=
ve_0
[  102.289496][ T5880] batman_adv: batadv0: Interface activated: batadv_sla=
ve_1
[  102.304731][   T67] netdevsim netdevsim0 netdevsim0: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[  102.314238][   T67] netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[  102.324278][   T67] netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[  102.334159][   T67] netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[  102.469673][   T67] netdevsim netdevsim0 netdevsim3 (unregistering): uns=
et [1, 0] type 2 family 0 port 6081 - 0
[  102.543054][   T67] netdevsim netdevsim0 netdevsim2 (unregistering): uns=
et [1, 0] type 2 family 0 port 6081 - 0
[  102.622429][   T67] netdevsim netdevsim0 netdevsim1 (unregistering): uns=
et [1, 0] type 2 family 0 port 6081 - 0
[  102.698368][   T67] netdevsim netdevsim0 netdevsim0 (unregistering): uns=
et [1, 0] type 2 family 0 port 6081 - 0
2025/11/11 11:01:26 executed programs: 0
[  104.788606][   T52] Bluetooth: hci0: unexpected cc 0x0c03 length: 249 > =
1
[  104.799432][   T52] Bluetooth: hci0: unexpected cc 0x1003 length: 249 > =
9
[  104.807512][   T52] Bluetooth: hci0: unexpected cc 0x1001 length: 249 > =
9
[  104.816410][   T52] Bluetooth: hci0: unexpected cc 0x0c23 length: 249 > =
4
[  104.824560][   T52] Bluetooth: hci0: unexpected cc 0x0c38 length: 249 > =
2
[  104.982601][ T5940] chnl_net:caif_netlink_parms(): no params data found
[  105.059249][ T5940] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[  105.066542][ T5940] bridge0: port 1(bridge_slave_0) entered disabled sta=
te
[  105.073685][ T5940] bridge_slave_0: entered allmulticast mode
[  105.081124][ T5940] bridge_slave_0: entered promiscuous mode
[  105.089124][ T5940] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[  105.096583][ T5940] bridge0: port 2(bridge_slave_1) entered disabled sta=
te
[  105.104018][ T5940] bridge_slave_1: entered allmulticast mode
[  105.111771][ T5940] bridge_slave_1: entered promiscuous mode
[  105.143334][ T5940] bond0: (slave bond_slave_0): Enslaving as an active =
interface with an up link
[  105.155734][ T5940] bond0: (slave bond_slave_1): Enslaving as an active =
interface with an up link
[  105.191407][ T5940] team0: Port device team_slave_0 added
[  105.201031][ T5940] team0: Port device team_slave_1 added
[  105.235802][ T5940] batman_adv: batadv0: Adding interface: batadv_slave_=
0
[  105.242802][ T5940] batman_adv: batadv0: The MTU of interface batadv_sla=
ve_0 is too small (1500) to handle the transport of batman-adv packets. Pac=
kets going over this interface will be fragmented on layer2 which could imp=
act the performance. Setting the MTU to 1532 would solve the problem.
[  105.269608][ T5940] batman_adv: batadv0: Not using interface batadv_slav=
e_0 (retrying later): interface not active
[  105.296300][ T5940] batman_adv: batadv0: Adding interface: batadv_slave_=
1
[  105.303516][ T5940] batman_adv: batadv0: The MTU of interface batadv_sla=
ve_1 is too small (1500) to handle the transport of batman-adv packets. Pac=
kets going over this interface will be fragmented on layer2 which could imp=
act the performance. Setting the MTU to 1532 would solve the problem.
[  105.331738][ T5940] batman_adv: batadv0: Not using interface batadv_slav=
e_1 (retrying later): interface not active
[  105.417552][ T5940] hsr_slave_0: entered promiscuous mode
[  105.424204][ T5940] hsr_slave_1: entered promiscuous mode
[  105.430828][ T5940] debugfs: 'hsr0' already exists in 'hsr'
[  105.437317][ T5940] Cannot create hsr debugfs directory
[  105.454873][   T67] bridge_slave_1: left allmulticast mode
[  105.460813][   T67] bridge_slave_1: left promiscuous mode
[  105.467853][   T67] bridge0: port 2(bridge_slave_1) entered disabled sta=
te
[  105.479304][   T67] bridge_slave_0: left allmulticast mode
[  105.485065][   T67] bridge_slave_0: left promiscuous mode
[  105.491001][   T67] bridge0: port 1(bridge_slave_0) entered disabled sta=
te
[  105.729562][   T67] bond0 (unregistering): (slave bond_slave_0): Releasi=
ng backup interface
[  105.741503][   T67] bond0 (unregistering): (slave bond_slave_1): Releasi=
ng backup interface
[  105.752583][   T67] bond0 (unregistering): Released all slaves
[  105.835828][   T67] hsr_slave_0: left promiscuous mode
[  105.842862][   T67] hsr_slave_1: left promiscuous mode
[  105.849433][   T67] batman_adv: batadv0: Interface deactivated: batadv_s=
lave_0
[  105.857469][   T67] batman_adv: batadv0: Removing interface: batadv_slav=
e_0
[  105.865850][   T67] batman_adv: batadv0: Interface deactivated: batadv_s=
lave_1
[  105.873344][   T67] batman_adv: batadv0: Removing interface: batadv_slav=
e_1
[  105.890846][   T67] veth1_macvtap: left promiscuous mode
[  105.897610][   T67] veth0_macvtap: left promiscuous mode
[  105.903553][   T67] veth1_vlan: left promiscuous mode
[  105.910171][   T67] veth0_vlan: left promiscuous mode
[  106.222498][   T67] team0 (unregistering): Port device team_slave_1 remo=
ved
[  106.255035][   T67] team0 (unregistering): Port device team_slave_0 remo=
ved
[  106.849861][   T52] Bluetooth: hci0: command tx timeout
[  107.366951][ T5940] netdevsim netdevsim0 netdevsim0: renamed from eth0
[  107.390747][ T5940] netdevsim netdevsim0 netdevsim1: renamed from eth1
[  107.409101][ T5940] netdevsim netdevsim0 netdevsim2: renamed from eth2
[  107.429220][ T5940] netdevsim netdevsim0 netdevsim3: renamed from eth3
[  107.687917][ T5940] 8021q: adding VLAN 0 to HW filter on device bond0
[  107.729157][ T5940] 8021q: adding VLAN 0 to HW filter on device team0
[  107.757652][ T1309] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[  107.764863][ T1309] bridge0: port 1(bridge_slave_0) entered forwarding s=
tate
[  107.814393][ T1309] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[  107.821819][ T1309] bridge0: port 2(bridge_slave_1) entered forwarding s=
tate
[  108.188295][ T5940] 8021q: adding VLAN 0 to HW filter on device batadv0
[  108.234481][ T5940] veth0_vlan: entered promiscuous mode
[  108.246943][ T5940] veth1_vlan: entered promiscuous mode
[  108.277479][ T5940] veth0_macvtap: entered promiscuous mode
[  108.288108][ T5940] veth1_macvtap: entered promiscuous mode
[  108.306578][ T5940] batman_adv: batadv0: Interface activated: batadv_sla=
ve_0
[  108.321859][ T5940] batman_adv: batadv0: Interface activated: batadv_sla=
ve_1
[  108.336901][ T1322] netdevsim netdevsim0 netdevsim0: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[  108.346834][ T1322] netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[  108.358941][ T1322] netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[  108.368475][ T1322] netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[  108.430497][ T1309] wlan0: Created IBSS using preconfigured BSSID 50:50:=
50:50:50:50
[  108.438794][ T1309] wlan0: Creating new IBSS network, BSSID 50:50:50:50:=
50:50
[  108.474331][   T67] wlan1: Created IBSS using preconfigured BSSID 50:50:=
50:50:50:50
[  108.484170][   T67] wlan1: Creating new IBSS network, BSSID 50:50:50:50:=
50:50
SYZFAIL: failed to recv rpc


syzkaller build log:
go env (err=3D<nil>)
AR=3D'ar'
CC=3D'gcc'
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_ENABLED=3D'1'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
CXX=3D'g++'
GCCGO=3D'gccgo'
GO111MODULE=3D'auto'
GOAMD64=3D'v1'
GOARCH=3D'amd64'
GOAUTH=3D'netrc'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOCACHEPROG=3D''
GODEBUG=3D''
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFIPS140=3D'off'
GOFLAGS=3D''
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build3388558029=3D/tmp/go-build -gno-record-gc=
c-switches'
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMOD=3D'/syzkaller/jobs/linux/gopath/src/github.com/google/syzkaller/go.mo=
d'
GOMODCACHE=3D'/syzkaller/jobs/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/usr/local/go'
GOSUMDB=3D'sum.golang.org'
GOTELEMETRY=3D'local'
GOTELEMETRYDIR=3D'/syzkaller/.config/go/telemetry'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/usr/local/go/pkg/tool/linux_amd64'
GOVCS=3D''
GOVERSION=3D'go1.24.4'
GOWORK=3D''
PKG_CONFIG=3D'pkg-config'

git status (err=3D<nil>)
HEAD detached at 4e1406b4def
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' -ldflags=3D"-s -w -X github.com/google/syzkaller/pr=
og.GitRevision=3D4e1406b4defac0e2a9d9424c70706f79a7750cf3 -X github.com/goo=
gle/syzkaller/prog.gitRevisionDate=3D20251106-151142"  ./sys/syz-sysgen | g=
rep -q false || go install -ldflags=3D"-s -w -X github.com/google/syzkaller=
/prog.GitRevision=3D4e1406b4defac0e2a9d9424c70706f79a7750cf3 -X github.com/=
google/syzkaller/prog.gitRevisionDate=3D20251106-151142"  ./sys/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build -ldflags=3D"-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D4e1406b4defac0e2a9d9424c70706f79a7750cf3 -X g=
ithub.com/google/syzkaller/prog.gitRevisionDate=3D20251106-151142"  -o ./bi=
n/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_amd64
g++ -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -std=3Dc++17 -I. -Iexecutor/_include   -DGOOS_linux=3D1 -DGOARCH=
_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"4e1406b4defac0e2a9d9424c70706f79a7=
750cf3\"
/usr/bin/ld: /tmp/ccimHo7N.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x104): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking
./tools/check-syzos.sh 2>/dev/null



Tested on:

commit:         ae901e5e Merge patch series "ns: fixes for namespace i..
git tree:       https://github.com/brauner/linux.git namespace-6.19.fixes
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D7b0bf36f8860281=
7
dashboard link: https://syzkaller.appspot.com/bug?extid=3D0b2e79f91ff6579bf=
a5b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-=
1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.


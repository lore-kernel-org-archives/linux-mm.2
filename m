Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98B6CCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010EC8E006B; Fri, 17 Oct 2025 05:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08D58E0016; Fri, 17 Oct 2025 05:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB598E006B; Fri, 17 Oct 2025 05:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C64078E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:11:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8719D8717A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:11:54 +0000 (UTC)
X-FDA: 84007038948.26.8F9B22C
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6222B20004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:11:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qvg8xPtd;
	spf=pass (imf13.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692312; a=rsa-sha256;
	cv=none;
	b=2q1gPlh3TvLA/WXx2GGpHlitt2lw/+S9abcbiG0YlmdnljYbzSTyxqqHKKbbZ2x6Bza/sa
	l5SmrnImKsyPBMl22nLkSxdlErXMdmW4YoO8iEfSHBfiH3FFhcbkJhzy0PrRa5htnXGPHE
	ZULQ4quduZ7VWSm6kTugL7Y5ZOGeytE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qvg8xPtd;
	spf=pass (imf13.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sqrnOqDkNbMqZtkMy5YftCQnn6xMaPqvu+kQgm+8STI=;
	b=f/F6SAicJgGyzrqjtvezaVxnQ49c/ZIIYeQoFJz56m0owxf8kikfb0sTplOqf3UpF22ifD
	JaWLvW7EKx8RaNnWexDTdeKZ967MQP/+lnfXVtFLoCZpDZ/tJLfpKJLBbotpoKRk0bpo5w
	aXEXHtvTPM9sWxXJw4j4bohO7BETkpg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692312; x=1792228312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sqrnOqDkNbMqZtkMy5YftCQnn6xMaPqvu+kQgm+8STI=;
  b=qvg8xPtdb21qZ2dUwwdXNnLm4ozZRwcN+91mcvQyGCPWsVEmM46vzcT2
   SgV0j/ikqLsuii9zQ0mfs2/fRX2xVxUCM9L1od/SuA9sPf4v6/+naFG+C
   eKBt26jjmo3ty8xtYRBT56XzonEsz3SjVbvSlTlccDOx/mMte/pR+I3g6
   TGg0BEhHPIf3HW0dOqUBkBRQCqdWFm7hH1930KV2arAHRTxpUQAQjpmRB
   hrPdSomdnmU0FTRVljzEbZovel2VhBeWtPMKc9lYi6sFNkjSglQwLKd0l
   BRP68XQcuu2zSkGM21ILBE8J0ZLRDtGyJT13ThNSRhqlzAQsyHSygoI6z
   g==;
X-CSE-ConnectionGUID: /XZEFEw3T0yrcXH6tMfWWw==
X-CSE-MsgGUID: 03ocDjC0SZSWT13vR12laA==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="4952294"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:11:51 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:17944]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.191:2525] with esmtp (Farcaster)
 id bad57f54-0874-430a-a722-e920635c2585; Fri, 17 Oct 2025 09:11:51 +0000 (UTC)
X-Farcaster-Flow-ID: bad57f54-0874-430a-a722-e920635c2585
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:11:33 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:11:17 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
	<linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>,
	<james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>,
	<sunpeng.li@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>,
	<dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <rajur@chelsio.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
	<joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>,
	<hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>,
	<chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>,
	<yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>,
	<herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>,
	<kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>,
	<ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
	<freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
	<linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>,
	<linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<tipc-discussion@lists.sourceforge.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Arnd Bergmann
	<arnd@kernel.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>
Subject: [PATCH v2 19/27 5.10.y] minmax: improve macro expansion and type checking
Date: Fri, 17 Oct 2025 09:05:11 +0000
Message-ID: <20251017090519.46992-20-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Stat-Signature: arzbb3q8fm7k1h834i4zupe3erbgdh1i
X-Rspamd-Queue-Id: 6222B20004
X-Rspamd-Server: rspam09
X-HE-Tag: 1760692312-871281
X-HE-Meta: U2FsdGVkX1/9dExfm8Bh6V6TMl7ngszFl5c35Nsi7RWdbjzyh1hd72pxMfLlRPiFYwISa3o8kAPtDGMHH8fnSzwOdUyrXl2754VWG/W/uaTJTjob/nFIajMgpoqsUJ5FOHfsQdr4BdzrmbRH2d3GFHEF6mrxh2d2RS8AYQgj0c/Bj+A2kz0eV/2jzE7gwYSA70rYWBYJz0vtAEo4xo25DrIknygefJWYejQbQ/f03Dw5LZ/2upv7LTKkH/C6QB0N96xfS6RK1D3MFoMUmyiD5Y+2A6o3X6WzfC9LwE+LJuyBuM252qO8wzQkQtcZht7pu8SagZfvRm8SBTBTL4oQMArYZb4eG6SgJKq33HoPDtKLbXNZ+MdP2PeURuox3kmmGafWEu31Sdi2aP3Tud90Me792V3RYJH2kO475Y1iZREcfw89wWu1GOF5cHEw5dMSpp7BTc4R7dyDh0HA2rFv8Op+oiQghJ4TGUcRshgoxr/cz/rh+GFkQXvpszbzGkNMVOagTJx6R+gEkEB7taIU70we2CzrjvO6pHWPDluCJIt+xSh99MpEYsMQ3MudR0TwuqXH2kG0mgLYGuPRU7o28LV2unaXp8b+/V/lQ0733OrRHxMbRcf2LM5s0I+h8R5JzVwnxT4NboegXhxUGq9vZUH3FktE+XZ5cMxkFTV7syQm/ro2PIS8TSQzjT52U0ZYAp8GJHXutl9gGfmOwqWRGGrHqovXZtN2fD/zFS1rP8Lj52jRdofvhwAwt9hhfrLqlsuUbw2ldx4Tj1tnobhWgh6K75lyXOi7I0NzecMtvamS8PfBeGPUz1n+MEitwpmi6NnUSi0BLjVFqeAs8t61uRqUp8Uu0Nts0ERbz/74uxSRZo5nHqs/8stOcSGg3Fw5B5X62tHN5oy3qQPAnIxadt5mbCgZFq1yRY/TxOXK45Uu6Scgw0nWsNa2StOb8AkZBtKMDcyF4gOmrkGV5HT
 oTg+cUuX
 rRh0VYV1vpqNT5FiYuXymy/t/aTTegZWFTlt7PxtVpa/vkRQUU+JWaUes2NmP+/oi83U+qBMseLJNJGAnHJ1mAgxqIJaXIy5F7sDrfMUeAzcbpLJeZAMdkiUChzEed16a1+PWm5g09OTTKRR84ji5WQEXo30ayX/mrDwV4F4GY3JpjD/i0eHOVFB6fw5J6fRJqrn2HHmYlOzaTVvbTh5uzOLqPHjNSULqW+m6sdYj4mIv9+AlD7vjWj2MQorm6rY4soiFKRPZQcDy67cDDYfyjWoQa1FcCes0FzVuK6npAtTH0g7Ni63YdnMa6g+DRYqsXjMEir3Hr2uL1DFIVzbhAoW+LaXDRNK/k8sJHEqiFTgx0ntD39eH+L7wj3yDH2Zomy3aB7BrBUOUrpa2DJBs8y+2nLg45CDKUngChdMCAV32yRYUhBmBYMHZIP86zW7XT2lgj2BoiBA/dwAoqXPF8+Y9YVhoUN3ajJN10P7+t81x1PI442P5HRlyfD7H86AiQcqtxXjQD5W0Iy85CMGPnTBfnaV5sSVtFOx6si4DafXb5zM6gQgc/+o6CIm9NsvsuMZQ2wAuVJL9ivT/VHtw6w97z4YWSlNqN1QaTAPPFy8OFYMn2Y6jj+Ec9QpdrwSFFSnQpUWTyvNS6zVjGumtEHStQ9E/g+WgeNYyGD1lMRXyMzkiu13Lr5OoFwpFdo8LFur8iJXX6iO3ndNUc3iK2NlUKmLDk4GsjWqeAA449snZ/NGyvcIS4l0oI3Cc+SRbMuVBz8QY09OXOF7gxGJDAP7eb0KsmaWcCimE1ytIVillL8NQqC7DIsDmS2l4x3fbtAJU6KbkFU3p0S4CDs1dR1xPBuqQ2Ra6GJLvc+YTftfrfdihHiN/l2vxUIwOnR1yC3UfleWcUyIKLgoAsvhcW8BzYIEMWA0Rx2aQX/ftKnTEwQLOUzjvKot7ekC97ssQscQFReXou9IU+3AlXjfyvnIRmq87
 2f5+OWGb
 gtaYB9G2MRdKCaU0wJHBtJo1FNdMslW20aIFVADpLd+YAQklXM/nKj0K6gVJwUXlBNs6QYufSp4qN45BHlMslTtrDBGK/E/VCx+V55C8HlPdB8hZz+sFANUrZ+KnzxBqICGbERm2PltmWvAlaBHcrvMSdB8rQfMecD7KRFFeCpYV1YCH1Ad9ktI89pddwsLIkL6z39xUWChzcg1UL+ozaYVvPgTjMMX43JBIVGEp6HOHAMgnSYEJdC+SnFfKWVjBHQmejFeHHnkPkSOurt5vEfuZI4n5V04F3TGPfj0puR5oIMvvaAkUIQNW/BmxNJJrwHDPMAd6FHNO1Wak+1Yqysdg35fWOiQpay1kvLUyxFzGW+mhhLcgILzkxKCNCZbNOolPVI+0BCR0Vft6C6G1pJ3wMbIesptQXafELGfk7lS77a6uholiv1nYDm5tJlYpnCcRbgjcsAPxbtURY3A5l3o28sHyIbpF0rjpkyclPrX50gt2Tka9byvsznhCgvYjXaSkxYwmIb6jvWglQ7g3pnr0WKhRZKEbLTamoX2q8xufcz1uMLigrtfyKVlkh8rMpJhALbhM+xLucj8ndPMYsd87+lQShqsS5YbnXb2YTiHT/aA2DxiAuiOzhVFKCxPwMA2zaozL2nkO/2R+rY0/u+kuy0oUIuysBT4nAL/ajxReGhJeuP+NRQuSWPjFCRIJQw3gxyWfr6iWHAfBF8JTzXOUCb4fXak2X93FYgv73TVW1dQV5w1MoWj6PK3zpJVv2Ou41+OwIlGDvsnD42qB/SeFUCeVpMG6W9AvXi9QkhC//OJ5lzG9NdjCe0rTyPZ/j0HTHycVRuJVrRZeVgG7tTHFFskdH3haDoPVb87T5I3dFuAfaceztctOArY0qiFvtv38RVjiLDwW8tPRmQJMzNgqATr52SS07cSZ6/NGkfhi3W8rChdy1Ad3uWr+AW2kpIQYC2epiAOv/sNIRMeV4FZ489Ve9
 8X+x4pTf
 hn36N8ZUEpjCO/QT3XeJssh5PMm7pbKz0IsaRaJKUti+HSlrRR+ku+w7LboTFVgCAPeTdRICRLvShCP2ZX171a9VJlCBjreabueu+uXD/XkeNhoHNoOd2fWSnhHvMIp+Cj9VXwepxZFqakmTrWovqfu/CrEq297Q+qNawc9F4qjYgZB7DmkpgNP//l+MHvIl9np7lyYG9NNj3+XswM2ZeUSqSb7tbUFk5F8TEx3lNlayP0f7oqQE85zL9mQrp0RasoSXf/k39YRIlFFzu+j6h2pLTSka/cq09nZH9TDh79lIIYDOOf48eZdkOV9pOnUe8rh6K+7Oz30mKMNuH9nuIhnRwT0rvkGD3P45/fElJEqU8FtWAWnpa1swOW+zxkeEyQz+RYUl+cOEZqTd308RAs8CFzatX3xbmsMKBcMHZy0oj3NmJ+vsyan9eOlT644E8fckBZFo41PXapxjwAwPbjiQFOAO1YbcsVh0JC/Q0l7Xd4qXgB93KfpMTbklzLXYEzICRpIpmTwU0Na9SlSCyvwaFOwR98n2c63nIXwD04D7dVFXQYc0/7lr0lNBSSA6+yLgK2zc+fL/SPEt3HMoJXYXQh0mDFisarcYVEqQvpihs7SgXuX1+igiJIhp2XcokgplcBgxls3zaTpfxkJkIJycxzc21ICeDeKl4IkjIFrp1oYi3ZpJ/3zkwinJOxbwnQS5ABiR7ajc5khJlhTIWdI5XHbOz0HpW70eYtGtF9PY8r7o8lUZPagQv2SSuvGwhJdGaPYSoEutLjsUAV+he85LM2pIrlIeiM1zOW2qas5ooTg5eye4aQCRQMo/DqcTakLPYotS3iNZAXvj+cL66uXSvKDVwJ83LuqFZ+8gptC9M+PrgOE+kyGErhYT4D/cUmyXcfCTf+wJUjxSuu8/v/1O6EEcAw6Qbn4B6dFtcLVdPFAhk9lvDGiNg93B3UoJf+oLAioFvuQiQjcVM0bhS2gro8LqO
 ThAxW8Zx
 5pzzH918waXejw68nUHTNAgBw6HaTuhknVCX/Em5FIrvFghErsapGkyHZ7kMDkCailiAZ4uRcmTu3S+h85xXxuehwWlXWOKBMZ5O8mn8AiJzTJ2Enx6tHrOuxUNWthteAvxkpD1XfhNqo1xJ7YhbprI4mhfmM6xQpD+AmR3M8bzoSIGj5IvXyjKHHj/6KcCv56Ijb1y0NQNJwXM9Yyr0r84ces8VrhtWEeAn8+3IAbbhvFvx7enNTuGIBAItm2N0XaieTneBRgvofts24YiRY4IFtAAvXfyZoVfd0uNA+h8g42YjFVh+S9LY25+kif4jSefO54GsN7byMSYUaqYp1iRWE22sr+kxmaiiI8YKijOFfJoRykKzDV2LE5UBMqnBwXfa3GUg3CAckCmHptbocIBzf94CBz0H2Fq/dhv5qKaii5RLsBZwAojtDcTZcjtcvLHfKI98qAKrxb1XH+sk6hCH/ZXV/2WYoiWJUsuJsfO6avqBD6pTvGTr9lvaVv98xsnwYsXL/Xgtxrx4+kWGBtN6bN36A1pu+ZvWZh407Nk3eUUvzlj1EgqzsFshSdMDS9VRQRvXdSsycOS32K0emAH42U9AxmwU9xRxrxtEObibue1IOSSeZrzzGEJLkX6g5Kwnc5CI3tE+hQKFh7jFT9ndaM+aIQSWvmezvb+U5L7BslVLP8AOTUPGReJj1uPBCc1vo+6dMNuXeicC7I10ANI2m89nCPGmGm6uReWF7BuJiPLqlOKmdh7bQl3C2EJGGN16XpW+C2LUx8jfbPRJJsNjms2zFN6inoy9sPDTtQ4Eg+Ygw4lmx+cSPOEU8tSn32zUfEjnzjgOozNEOhNIeEH23okbp81NfovZLJh16RGi7WqrWgeVCUIUVJgoYLY8ZQe4jxqQe1Ss1cmad61Bqu8keIm29qg35BKiONNvlxcGLQySifGaZWK1STRSYN+UCkB5CH7Gd8hNBpmBaMocZWPSxR5/+
 yEWhriDE
 E+DZa4nkGvy5Yqd2Obz+qFRfhH+DbL33v7ULrCEvvbYgiEK0TT45rDX5DJeQDfq/pXyJCJte1HYi1rHWKIyIgAqjb4ls=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 include/linux/compiler.h |  9 +++++
 include/linux/minmax.h   | 74 ++++++++++++++++++++++++++++++++--------
 2 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 004a030d5ad2..28b21e372751 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -251,6 +251,15 @@ static inline void *offset_to_ptr(const int *off)
  */
 #define is_signed_type(type) (((type)(-1)) < (__force type)1)
 
+/*
+ * Useful shorthand for "is this condition known at compile-time?"
+ *
+ * Note that the condition may involve non-constant values,
+ * but the compiler may know enough about the details of the
+ * values to determine that the condition is statically true.
+ */
+#define statically_true(x) (__builtin_constant_p(x) && (x))
+
 /*
  * This is needed in functions which generate the stack canary, see
  * arch/x86/kernel/smpboot.c::start_secondary() for an example.
diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index e3e4353df983..41da6f85a407 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -26,19 +26,63 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-/* is_signed_type() isn't a constexpr for pointer types */
-#define __is_signed(x) 								\
-	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
-		is_signed_type(typeof(x)), 0)
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
 
-/* True for a non-negative signed int constant */
-#define __is_noneg_int(x)	\
-	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
+#define __types_ok(x,y,ux,uy) \
+	(__sign_use(x,ux) & __sign_use(y,uy))
 
-#define __types_ok(x, y, ux, uy) 				\
-	(__is_signed(ux) == __is_signed(uy) ||			\
-	 __is_signed((ux) + 0) == __is_signed((uy) + 0) ||	\
-	 __is_noneg_int(x) || __is_noneg_int(y))
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
-- 
2.47.3



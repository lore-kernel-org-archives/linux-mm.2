Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 736CBCCD184
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 01:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B276E8E0007; Sun, 12 Oct 2025 21:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD80E8E0002; Sun, 12 Oct 2025 21:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F288E0007; Sun, 12 Oct 2025 21:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 826D48E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 21:29:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B24085A1A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:29:06 +0000 (UTC)
X-FDA: 83991357492.21.6F75C85
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6F00D80007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:29:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760318944; a=rsa-sha256;
	cv=none;
	b=PVmpI4hSSBaVkxS3MM24Kw2U4/onXo/1SgAM3jsTO7NybvkXW3VXLSEjwLS0BEoJ+PSNRF
	2Ozy7FX+o9uFv78qNQHm7gz8kLrwVVXfabyC7jPMJdAxpDns//19CaxoNP6jtEsIEaOthT
	zuxFVIDjRLu8d9T8T/gshVBy3OP6WLk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760318944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BcO4IcU6oK94sppHs6KsUu10oK6LJgExrblg+JJRY8w=;
	b=KS3XeO5Y3U2dLDIrz9AFW+xOD8zaYJ4+SZiMgR/GrPwva78tJ3FEuriBcuaH60jSo0DWW0
	nJ0t95GZX/nRM/wDZJHGNVn4BwtnCwURsjNpa/qxeWnNcdHZECgyMfFxRHVVmcEnRrmgbw
	J/CGyZ5i0vz0TjyCBi8XsmUZ4dGJ9Ls=
X-AuditID: a67dfc5b-c2dff70000001609-c2-68ec55dc252c
Date: Mon, 13 Oct 2025 10:28:55 +0900
From: Byungchul Park <byungchul@sk.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
	tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
	amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
	linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
	minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
	sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
	penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
	ngupta@vflare.org, linux-block@vger.kernel.org,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	djwong@kernel.org, dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
	hamohammed.sa@gmail.com, harry.yoo@oracle.com,
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
	max.byungchul.park@gmail.com, boqun.feng@gmail.com,
	longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com,
	yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	sumit.semwal@linaro.org, gustavo@padovan.org,
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
	yuzhao@google.com, baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com, joel.granados@kernel.org,
	richard.weiyang@gmail.com, geert+renesas@glider.be,
	tim.c.chen@linux.intel.com, linux@treblig.org,
	alexander.shishkin@linux.intel.com, lillian@star-ark.net,
	chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 28/47] dept: add documentation for dept
Message-ID: <20251013012855.GB52546@system.software.com>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-29-byungchul@sk.com>
 <aN84jKyrE1BumpLj@archie.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aN84jKyrE1BumpLj@archie.me>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH89z79OltR8m1Q/dMsizrZCpGNicJZ4lxI2bb/WLmdDOZL5lV
	7tZmBVwLKMZtQIdj6BjUgFmLUiCtKEW0xSIvXRAipjgYyJjNtgLDgpJS2Rit7o2OYsz8cvLL
	+Z3zz/lwOFZZS1Zy2qwcUZ+l1qmIHMtDcbXr/e/OaF4KXpNBeL4EQ3Wzg8DghUYE9/+2sFDc
	FsUQ9fQiqBoyseBoKWTgj4sLBII9cwhm7ScQTF97E6L+OwzciswgsAcWGAh0fYGgps5FoPZX
	PwstvaMIPA1FBCbLL7MwHIiHH8KzBLyVxwmEhqoZsBZ5JHDaYkJgrG8mUHXaiaFtvF0Kv1SZ
	GGh0boUx+xSGG+V1DFhOGWPlLgOVTR0M2AuSYKLBLIWoNRv8X1di8I7+KIHglInA2PVjEmgt
	GJdCSXsYg/P2ovD8tA46PV4MvVcmGBhuryZw4uJlCYw6ohK42TiIofmOjwGv+RyG79ubJGC7
	NcSAq/87FiJlidB0r47AyXtTCIIROwv28Kz0tQzhfnEZFs673IzgOONAwrzNyArF5YvUMzPL
	Cp+7Dgm2GzNE+Cs8QgRPxIqFvjoqVPSvF9rMfqlgdeYKroZkob5zmtmWsku+KUPUafNE/Yub
	98k1ngcD+ODxhMMRixEVoPr4UiTjKJ9KLw0XsY+4ZqJbEmPMJ9FQ/7coxoRfTX2+P5dmEvg1
	1Ot6IC1Fco7lWxPpUMvtJfEk/yodGHEsLSh4oPOtNSg2pOQLER34qgU/FMuo95vAErN8MvUt
	TDOliFvkRHp2gYu1ZfxaOtYfIjFezj9Pu9zXmVgO5SdkdLTGRx5e+jS92uDD5Yg3PxZrfizW
	/H+sFbHnkVKblZep1upSUzT5WdrDKQeyM51o8XHtn/yz+wqaG9zRjXgOqeIUmo6gRilR5xny
	M7sR5VhVgqLi2F2NUpGhzj8i6rPf1+fqREM3SuSw6inFy5FDGUr+Q3WO+JEoHhT1jyzDyVYW
	oO1d6YWr38uJz68dc7exKfsr4LdcqanvhfDJwNFtPfXPOUD25Z5/daua3OkV75R8utn6wdaj
	e1rn3ni7L0224sKOLZ9VlenXXk3tcCx/xbbh401p44Nx0RXSI5bJZ2xpnvSQMrzKsLNsMvzz
	W1uWPUue2Lmx092794Ax8vrI7/6NN1OTxlXYoFFvSGb1BvV/O4WOPLQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTHfe69vffSUHLtSngUh0mNuhGBmWh2si2bn+aNi8ZoFqNmmTfz
	xjaUYlpXxYWEWtkYvqx0aZFWpULoDNSBpaiM1DR1q0Eo2oFKJtDhqoLQsYzyJhTWsizzy8nv
	nN/5J+fDYUl5QrKaVWuPiTqtoFHSUkq6631T3sCn46p3JhtWwSOjn4KpeAUFF5vdNFR4aiTw
	4McmBJGpCgQz8w4SytuXKEhYggzE554wYDUiWPIFEdjCFhLcXiMBky2LNIzd+RuBdThKQ/Wo
	kYIJ11kE9ucOBkZ/2Q6xSIcElgZfEPB4ehyBK7pIQNT/DYKErRBq61ppmA/dJ6Ha+gDBleFB
	EkZaktIbHELgu3qKhmfmNhJ6oxnQNzVBQ6f1DA2x8EUC/myhwXnKJ4FLDgsCU30zDbZLHgra
	f/+JgfDYAgEDNgsBTZ6dEHE9p6DLXEck70tuXc8CR7WJSJYRAqzXOgiYczUy0F0/QIGrbD04
	Qr0SeHrVzsDC8GZYchZDsOkFA4PfWaltNsTPlJ+n+MbWGwRf/muC5t2X3Yiff2VBfLzBRPLl
	5mR7Z3yC5E+3HucbusZp/tXUQ5r3TTsp/l4d5qtCeXy7fZDhT9/+jdn93gHpB4dFjdog6go+
	PCRV+WZ7qKNnFCemHSZUhuozKlEai7ktuPZpQJJiiluPY6HbKMU0txH398+RKVZwb+HO1lmm
	EklZkruZjcPeP5bFG9xHuOehezkg4wDHb9ai1JKcMyLcc85L/StW4s6a6DKTXC7uXxwlKhGb
	5Gz8wyKbGqdxb+NIKEanOJNbh/037hJmJLO/lra/lrb/n3YishEp1FpDkaDWbM3XF6pKtOoT
	+V8UF3lQ8ildpQtVt1C8d3sAcSxSpstUHWMquUQw6EuKAgizpFIhq/p6RCWXHRZKToq64s91
	X2pEfQBls5QyS7Zjn3hIzh0RjomFonhU1P1nCTZtdRny1e4xXT8y9MRW9RJrMrW33u14PNTd
	pzj4cYH35Q5DW9Ce2RxOLzDTipx9e3M/c3hItrt4Y9aKPZIN/q41+7e9uTUnbl678EhIK32m
	adty4ORfm2LpwmT27NkLBuf3gcim46Ur/TUVI4nRn2fOF+Wv+KTh2wtfhWN5fTmGtXczVlUO
	KSm9SticS+r0wj/gdz/3kAMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6F00D80007
X-Stat-Signature: orifb6a8mbanzsxijb87pawzc3oni6jx
X-HE-Tag: 1760318942-215593
X-HE-Meta: U2FsdGVkX1/1mpCE6vL0hMQ4+BxbRfYb95P65WizM1C8jyqOkcb+2pGJ4Baomkg+niArz6NjPOt9Hso2ioRDg185omkTkutJsC/zTq92w4OLAOHxMps/8uBK/PeRoKyQqYfajWJrQ2W6Jty282F4uTTQt77+P6IfeHKzeEZ5mJmbsra9Zax2q8NEAfxYM1lwYuGEy0CfSBsIu77qDmbzmfLMVmqD+MbCaeZbh85OVeY7aTXiMkCkJwZlWj/tsusllMhbF75SUCH4iJAKzilck2fKKNqneemMAqZILiij6pcZpHtBl7mzQ1oUhpo6TpcPvA1Whu1V1jFQpJJdextuaIC8B6oboTps0LElWe4ivb1j7qdTHHrfYx0w8QtZ42vyfY9Zcel8twm0Oekc7+/TLdKZADBww5Fv8TggTCbDNdGRhN/fdxYgNyL9T4CU2P04eGSGtaPeZKRkMSNIyc/xPwBwi6kJ2fhwZ333s3iamWKwnPUbbqkpThADcvsPcC5VIwcpH+j5pPELoHUV1u4fMZuhOfzJP1SdcjPGsazl0Ck2eEc+80e0X7a3EMaXQ6QDeMphkR8jX+WYPtwbN7lY+j1YjjpBhQmOuCzAdPU1jkumCV75zrwvrC670ZTeYQQDIUjGdsXPggn9YPixTYva1Nb3RhB+82mIwab+GZQ9t+y5jHa2eZAlLw6+VTxiNFxc0Wmj2dbQqrP3ktH697WjKL7tva+p+nfaN8aXjR0JME8YWwJInHJqf6/WEAz/Or4HWMEBywEG2s7G3ROEFfA5MWm/asu+nFNHHDRymJUj1irwd9auFuT20UjnLcplqPCW0J2SItyEKnHnzMD0bcOyz3RmxABWS7xUpNQt55XVFu55CxsybPvFhbN+n5PUEd5neZrHhnCLwIUoS4ra2WeUpOZcfzDfAnnWRgcQCVrLU21WyW1SxAJuFMdJPMBy79Tl/1oHl6ezr1XG7wObgKx
 c/bnaqYq
 ZPbt+K9JZS3JYRA+zed2Ry5Wn8Uefv3Emm/aTQ5sujkH3XR+3rhbIU8Nr4BfydR6bioVy2FvhZaZEJgluGCFlB4gaZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 09:44:28AM +0700, Bagas Sanjaya wrote:
> On Thu, Oct 02, 2025 at 05:12:28PM +0900, Byungchul Park wrote:
> > This document describes the concept and APIs of dept.
> >
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > ---
> >  Documentation/dependency/dept.txt     | 735 ++++++++++++++++++++++++++
> >  Documentation/dependency/dept_api.txt | 117 ++++
> >  2 files changed, 852 insertions(+)
> >  create mode 100644 Documentation/dependency/dept.txt
> >  create mode 100644 Documentation/dependency/dept_api.txt
> 
> What about writing dept docs in reST (like the rest of kernel documentation)?

Sorry for late reply, but sure.  I should and will.  Thank you!

> ---- >8 ----
> diff --git a/Documentation/dependency/dept.txt b/Documentation/locking/dept.rst
> similarity index 92%
> rename from Documentation/dependency/dept.txt
> rename to Documentation/locking/dept.rst
> index 5dd358b96734e6..7b90a0d95f0876 100644
> --- a/Documentation/dependency/dept.txt
> +++ b/Documentation/locking/dept.rst

However, I'm not sure if dept is about locking.  dept is about general
waits e.g. wait_for_completion(), wait_event(), and so on, rather than
just waits involved in typical locking mechanisms e.g. spin lock, mutex,
and so on.

[snip]

> > +
> > +   context X            context Y
> > +
			     /*
			      * Acquired A.
			      */
> > +                        mutex_lock A

			     /*
			      * Request something that will be handled
			      * through e.g. wq, deamon or any its own
			      * way, and then do 'complete B'.
			      */
			     request_xxx_and_complete_B();
        /*
	 * The request from
	 * context Y has been
	 * done.  So running
	 * toward 'complete B'.
	 */

	/*
	 * Wait for A to be
	 * released, but will
	 * never happen.
	 */
> > +   mutex_lock A <- DEADLOCK
			     /*
			      * Wait for 'complete B' to happen, but
			      * will never happen.
			      */
> > +                        wait_for_complete B <- DEADLOCK
	/*
	 * Never reachable.
	 */
> > +   complete B

			     /*
			      * Never reachable.
			      */
> > +                        mutex_unlock A
> > +   mutex_unlock A
> 
> Can you explain how DEPT detects deadlock on the second example above (like
> the first one being described in "How DEPT works" section)?

Sure.  I added the explanation inline above.  Don't hesitate if you have
any questions.  Thanks.

	Byungchul
> 
> Confused...
> 
> --
> An old man doll... just what I always wanted! - Clara


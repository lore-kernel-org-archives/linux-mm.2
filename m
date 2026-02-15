Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 845A7EF5868
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 06:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5AA6B0005; Sun, 15 Feb 2026 01:45:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2C46B0088; Sun, 15 Feb 2026 01:45:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42FDB6B008A; Sun, 15 Feb 2026 01:45:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3130C6B0005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 01:45:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7C9A1A0A60
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 06:45:50 +0000 (UTC)
X-FDA: 84445755660.14.8E1A4F0
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6FAA5100003
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 06:45:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=kxYs6qEq;
	spf=pass (imf14.hostedemail.com: domain of dirk.behme@gmx.de designates 212.227.17.22 as permitted sender) smtp.mailfrom=dirk.behme@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771137948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AdcHYF4G/k6Zrjgfn4uMhaEygzOQ4eiFPqSXvL8Shyw=;
	b=WEUB8eC7ApIbpMarLGMUdfEIsLp5MsEXW36wX7sj7EBG9bUlpPhzgtdf/fEtrzOq63vr+E
	8vNlB7MnzOJdBltKuN7k4ppLbXbvOX/obWPZ4+QitYhxCtLrqWZIGWm2PrBlKUXwr1dZkq
	1G095tyKesZVFRMtXmHNolci+0N+1Rs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=kxYs6qEq;
	spf=pass (imf14.hostedemail.com: domain of dirk.behme@gmx.de designates 212.227.17.22 as permitted sender) smtp.mailfrom=dirk.behme@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771137948; a=rsa-sha256;
	cv=none;
	b=Ot2dJ/SP1NRfwNi4YpPxnU+b+lp7Qbl+il8g3RYg0QH+7N58bCWO+2Sy3yOiMRVjKVIORY
	II5AfBb+EtxbukE+olJJDDnAtq4ZVtZtP1sQaJNlCP3QCXUNuiDJkCFBa//yWF5l8udOw/
	cqnNuW9lKaBcQ1bhzSdlzc8NKFWx/sU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1771137759; x=1771742559; i=dirk.behme@gmx.de;
	bh=AdcHYF4G/k6Zrjgfn4uMhaEygzOQ4eiFPqSXvL8Shyw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=kxYs6qEqggL4ULenD08/H++rJS0Qa/he2vbgbQgsRcdvarSVx5NCEuvol5nZwqF1
	 gMmKWgicGg4pKMqidqBV9UV9zpqaX4hWeJ/okoQKhAXHSFzRaNopdmIEt/7T5nsPf
	 P6Zn6sCQjN5LXQ6Ki/BZY2JqtYZIIH4rDUFAQzWdw00Po45heUOMN1R7uaTRpt4KD
	 LFsXG6c25x4RjQb8bDxc9Wj/uJv5oDgu42hMlr0sqZuP1sf1bjpK1eLbG5GsRhiLq
	 rwbDKh3cMZ2k1p/mz3PK56xYvZyaEtSslfwY3WbwIdo0k1DijkkubS+3volbhR5Tk
	 L6HHLjNGIwoifE21sw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.178.42] ([84.129.20.229]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MRmjq-1wKXx63E5K-00OJ5P; Sun, 15
 Feb 2026 07:42:39 +0100
Message-ID: <ab0b9f9c-3a05-42f3-b4a7-ddb6ab0d37a4@gmx.de>
Date: Sun, 15 Feb 2026 07:42:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 31/42] dept: assign unique dept_key to each distinct
 wait_for_completion() caller
To: Byungchul Park <byungchul@sk.com>, linux-kernel@vger.kernel.org
Cc: kernel_team@skhynix.com, torvalds@linux-foundation.org,
 damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, mingo@redhat.com,
 peterz@infradead.org, will@kernel.org, tglx@linutronix.de,
 rostedt@goodmis.org, joel@joelfernandes.org, sashal@kernel.org,
 daniel.vetter@ffwll.ch, duyuyang@gmail.com, johannes.berg@intel.com,
 tj@kernel.org, tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
 amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
 minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
 sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
 penberg@kernel.org, rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org,
 linux-block@vger.kernel.org, josef@toxicpanda.com,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org,
 dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org,
 dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com,
 melissa.srw@gmail.com, hamohammed.sa@gmail.com, harry.yoo@oracle.com,
 chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
 max.byungchul.park@gmail.com, boqun.feng@gmail.com, longman@redhat.com,
 yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com,
 netdev@vger.kernel.org, matthew.brost@intel.com, her0gyugyu@gmail.com,
 corbet@lwn.net, catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
 gustavo@padovan.org, christian.koenig@amd.com, andi.shyti@kernel.org,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mcgrof@kernel.org, petr.pavlu@suse.com,
 da.gomez@kernel.org, samitolvanen@google.com, paulmck@kernel.org,
 frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
 josh@joshtriplett.org, urezki@gmail.com, mathieu.desnoyers@efficios.com,
 jiangshanlai@gmail.com, qiang.zhang@linux.dev, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, chuck.lever@oracle.com,
 neil@brown.name, okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com,
 trondmy@kernel.org, anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
 clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
 kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, broonie@kernel.org,
 kevin.brodsky@arm.com, dwmw@amazon.co.uk, shakeel.butt@linux.dev,
 ast@kernel.org, ziy@nvidia.com, yuzhao@google.com,
 baolin.wang@linux.alibaba.com, usamaarif642@gmail.com,
 joel.granados@kernel.org, richard.weiyang@gmail.com,
 geert+renesas@glider.be, tim.c.chen@linux.intel.com, linux@treblig.org,
 alexander.shishkin@linux.intel.com, lillian@star-ark.net,
 chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com,
 link@vivo.com, jpoimboe@kernel.org, masahiroy@kernel.org,
 brauner@kernel.org, thomas.weissschuh@linutronix.de, oleg@redhat.com,
 mjguzik@gmail.com, andrii@kernel.org, wangfushuai@baidu.com,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-i2c@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-modules@vger.kernel.org, rcu@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 2407018371@qq.com, dakr@kernel.org, miguel.ojeda.sandonis@gmail.com,
 neilb@ownmail.net, bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
 dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
 alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
 tmgross@umich.edu, rust-for-linux@vger.kernel.org
References: <20251205071855.72743-1-byungchul@sk.com>
 <20251205071855.72743-32-byungchul@sk.com>
Content-Language: de-AT-frami, en-US
From: Dirk Behme <dirk.behme@gmx.de>
In-Reply-To: <20251205071855.72743-32-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:aWhWMgelEECPmC8s4cDGobXX6S7QtiNME6Biy1AWp+3e//5sbQ5
 y9wEC0GO6LExJy0TTxPgi7hn9knznFwU+a3hirtKlPOCAxJAmR+f4VZcqBi5p6St8Nc30fU
 oiV/7SpKGjIQCoOsBc01ZMd0fVmfFXBllNez+QIS6oLVPBXw4NlthHwsLkGV+AXk0sSs7K4
 GRT5XuyhIHBhQJdzZpoIw==
UI-OutboundReport: notjunk:1;M01:P0:OmiIocz3wZw=;W0wkBau9AOTYHToDyhFSvTXvQnG
 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
X-Rspamd-Server: rspam11
X-Stat-Signature: mzoymjtbk4dofhpz1ibm51o4ir3txr1s
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FAA5100003
X-HE-Tag: 1771137948-500851
X-HE-Meta: U2FsdGVkX19HXMqh+RdGIBdvgZzyicMIG0/b7jCbGZlUf8SCkGJW6wGEpiTvAjo8ymI/Go89kfnXkmrXrCQuwxKJbDURb8fakVLL5w0V8aH/EdiKtsF41V1BZBgZ2S4x2ngrbXcvytRQCT/H1mj+zZEODWDe8T3SuILQEmOX0PzUgpE+hLwFZhENyNQ34Solc+AZTtZhYdEJlLugcAoOvlPZP3LtTI6u+NqbWuYTDazlxpEdP61VwDk/7CVJNDNKpZGdlH3CgTxvl5wFBamGbtW3ZhvAFB1LsQt5UXUFDjdLMJG6cSKlxgGdCj8wFU6d0xKEYTyAajYK/ChsH7iUb2r+qG/hiHc2zdkOeLyvnop1vLciR5yKjG/22oZQqBGoet+TaMlVI9qqdTX35iWRvGxMd69AUtTFKlESmLzv1kRMgXYraMOKcLhiZqNFqcl7K3krzOZHh7edudGjTtI84H+UW1NteRvJhok9TjnNok7gGNKvteOi7IgWs6ZawE3EBcDyWqz0PUcnWiBH1CwJDpxHfAtcyd1A4W06aJj1QykG6k+50MnWi6lGp3xKvcf9KslvEJzZd//LX04EnPXCZXJ/ox7W+g3rfxicXzKSP2e29tqhJR/iWKgYw/O+v8O/6NxEeBYAN+BJ3CjNGV0+CCiGFpcSzAum9Rgzy3HOyC62rupEV2DKjzj5+VlaZ4aeigJXgg2USfs6Fby4dAUrCJX76jaurcFeWLbaluhnfrykW3c89nGe2wtGigjaW1n3Q9YJ2CGNgqcapRiEKUBhGaNfUljOiqCI/6ZNZHGJ4vurlj7acqe3j8E+kPLgrP9TyM0UIREDRFjEhWT+NZkUP3Ij5jaUt2AvdXnk+jqqFvltlXeSxhhY1zIIALLMoVVXtaQmHudFsZYDXW2pOCDBCAdy6bw92Jdk2gPgAtz9HzJK2XhYuIqg75rXy4vtBAWuhdOmj2gsR2+/ULLiUD9
 3ETrV0cl
 42T84RZ9/3DaQLpBlw9XcQI+xZ6QRfvN/x68Eyj7WSL34OQnWE7hV9T0uivWC1Eip7BYiuDA7kPRaoY9yVXBfmyJFvaaTVurRrsN9uRvU17BBxaNzggCcz0FbddN4C2diCDLaApEQlfy0cIx5y0C47HtKlv/wZ78BAsEuWKYVr982qKUP9fchEZGFAakAyi3bLbD1iUtfEWssl2eWUDxDLWgC8mx10biX+MePUM7cx3lt9oc7nTqRrWITE94f6wodtZ9FeF2DEt0fdrg5Kd/7odLwq2Uf73HqNiD3dIY+p7yXYZ4cBXZlNPz/8ci82iz3whMIQ/3vw60otLmcFOceYh62iFcBFKEfT7H71QGbM/sv37ljIVZCzL7UJm9rkFdIuJq1olL5lc3PrkRQ2+XtVg4nlVaIrrVE+Uoe+DgBceENhkIt+j6sqIpw9X5P91vIt5Zvf3Qm0Lf6tPB+RCUSMx20hn5c3XugAYLfaUHDSd4BhdjhOcVMWlDzBG7BdrkW+Tuuy0+Dh2dQZKzspYaKMQbg0Nz2sctQ1xi6KOXsC5VBPUMqMiBRUo0kq8uFkD3SWDBZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.12.25 08:18, Byungchul Park wrote:
> wait_for_completion() can be used at various points in the code and it's
> very hard to distinguish wait_for_completion()s between different usages=
.
> Using a single dept_key for all the wait_for_completion()s could trigger
> false positive reports.
>=20
> Assign unique dept_key to each distinct wait_for_completion() caller to
> avoid false positive reports.
>=20
> While at it, add a rust helper for wait_for_completion() to avoid build
> errors.
>=20
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
>  include/linux/completion.h | 100 +++++++++++++++++++++++++++++++------
>  kernel/sched/completion.c  |  60 +++++++++++-----------
>  rust/helpers/completion.c  |   5 ++
>  3 files changed, 120 insertions(+), 45 deletions(-)
>=20
...
> diff --git a/rust/helpers/completion.c b/rust/helpers/completion.c
> index b2443262a2ae..5bae5e749def 100644
> --- a/rust/helpers/completion.c
> +++ b/rust/helpers/completion.c
> @@ -6,3 +6,8 @@ void rust_helper_init_completion(struct completion *x)
>  {
>  	init_completion(x);
>  }
> +
> +void rust_helper_wait_for_completion(struct completion *x)

Please add `__rust_helper`:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit=
/rust/helpers/completion.c?h=3Dnext-20260213&id=3D1c7a6f48f7eeb3014584d2fc=
55fc67f0cbaeef69

Best regards

Dirk



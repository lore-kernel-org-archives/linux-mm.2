Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3A8CA0EE0
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28357900211; Fri, 15 Aug 2025 04:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234558E0002; Fri, 15 Aug 2025 04:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D639900211; Fri, 15 Aug 2025 04:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E01FB8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:27:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 933F2C08F6
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:27:37 +0000 (UTC)
X-FDA: 83778312954.07.CF8B60D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf12.hostedemail.com (Postfix) with ESMTP id D6F894000F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:27:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755246455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bFNmEi85GaK3LJUYizvOObUBPtwpITu9C6zmdVej0W4=;
	b=Fny5DCy99ujYr9ihW2bTmyizoZ9ZPWiHsJBLKEf4iiNGmeMFFpzr+wRM0Xr4HxwLi0TFuf
	52+780RvP0UdKf4MDN0yecnuiJJwB8NBtbyA0kSArbYD3rBHOjpwC0OnxWzDuiMzDUdtNf
	oXQTYobFbgYSBxkVoXDMBkk4nvd5OS8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755246455; a=rsa-sha256;
	cv=none;
	b=a+mkuX7EDQQTfRlTqC8qSSqGOQryuTvf5Vap7tw+tJ+QF4QVyC0GS9IXD9e2EfLKBuLiBz
	spUwLBo+aU5wU1lUZGNyDhsC+TmcroQuFYEG2c5qhTmuMfXNnOnWLv9obfKV2Kyl+rz2/3
	bXx0vdbuKLx934/d3JJnNH2O8Pa/qVs=
X-UUID: abff620279b111f0b29709d653e92f7d-20250815
X-CID-CACHE: Type:Local,Time:202508151617+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:339357e6-611c-4c45-9af4-4b0f9ad93f29,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:bc8e9e1cfca9223f5b74cc50e33c6883,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-UUID: abff620279b111f0b29709d653e92f7d-20250815
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1281589497; Fri, 15 Aug 2025 16:27:25 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id A5724E008FA4;
	Fri, 15 Aug 2025 16:27:24 +0800 (CST)
X-ns-mid: postfix-689EEF6C-527582324
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id B8201E008FA3;
	Fri, 15 Aug 2025 16:27:18 +0800 (CST)
Message-ID: <bef49dcb-8619-4448-b8d7-6dca3a6cb456@kylinos.cn>
Date: Fri, 15 Aug 2025 16:27:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to
 address process dependency issues
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>, Oleg Nesterov
 <oleg@redhat.com>, David Hildenbrand <david@redhat.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 len brown <len.brown@intel.com>, pavel machek <pavel@kernel.org>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Nico Pache <npache@redhat.com>,
 xu xin <xu.xin16@zte.com.cn>, wangfushuai <wangfushuai@baidu.com>,
 Andrii Nakryiko <andrii@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Jeff Layton <jlayton@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Adrian Ratiu
 <adrian.ratiu@collabora.com>, linux-pm@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <20250814143717.GY4067720@noisy.programming.kicks-ass.net>
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <20250814143717.GY4067720@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D6F894000F
X-Rspam-User: 
X-Stat-Signature: k38y1su5jauie4etxg6cpfq7guuxi5tr
X-Rspamd-Server: rspam09
X-HE-Tag: 1755246454-559994
X-HE-Meta: U2FsdGVkX19+dlR2ePriRKEVD7mU7gPLCk/h3jnIh5rpQhw6V5RSpDYIbPtP+SXRTdzPRSxjpnwKkVqO3j1FtvYRHuOQLc0/kJc7t/25FvT7gKLJ3fV+jukQriGpIRyOA4Y0mZAm4IZ6g15MdDvNHU2avf8JF1y6ZrvGbt0wIAM/QILYSfqpy9U6TYMRPilNgNYMcYiMsJ01OzxQ4egCyW9dwNbSFve197KuVPik+9Pj//CO2P7fR1fRdNZ5AF9DSe0Ia7NkKthVgdUB+uFGQkdOyPydmF2Ehqrmme/IEbbSbP7v6nCIzTJXobHuocn2WEzG7+4Ty2Hx2x79QN4atDxmJsBF/wCUKoxysy25V1T7Weci+xgj9Vs/bWGH8dPzAJwgMKIeapfMZVGrsYbfDQ2ogQQnE8pIxuPFq3dU+u9q/KC3QypyK53k5vESnnDuUnGXClf65ASRQBfXxKnOnS1xG5H3c+cyBn4fRklU358vlGJtOC6yqvXrvI9LsVysJuNKjLKwiBCpZXcehw6bPqqUcXUtP/1al+cQEE+lad2TyB1V/oVRUNR2rpFWGgsWzLXZDMOqUQFeRXajMfl7+ozbL/jYk4p3V1BdIzASJy92go4TmLHM4l02DHCsjoj+A8IO9TjnMZbEl2jUjE1NmusQufpedSa07EV37A56/A8jrzfwapfM0M0aqQeH940hVN3GdHCH67zulb9DsjSR73Nap17AijgD1h+tYaXh7N4K8OACA6rOATHTVrvbkNfgb5tK1ELl0XLZzBTg3EqFw7X8V0lOc2GE2RPDxmGCMyO4BTsbvBa3mT4n+VQX+QEuzEpxSESD7zbQe/IA3rm9fwsx/emg33dwSkZDZekBWQvCQuOkmDzS/svQAOL31vO/oQjE6SxEPSoIfvudhnnobbunihfg8V5hQw7FrtM1eEofmM+Y3UTp5m9FdpSKJ2rxZkr7tRVHBXl02IejnuU
 9eJzOEmr
 2jfDKBo2+h4abRFpKHG1eL0lRarNkSLz2Lw/gf5mFaKBKGnQWk/SL/4LzoeDfCsVf+Qz93P8WNkvWKl/2vaIFKW8oNwlWYz3L+cdiv2f1mgmjnA2OhfI+OREj7jQ4C6trgX/dPNloMMkkj/rjo3msZ210VLypu2ynTu41bR7CeL/nyQdpC815nwyxA1Q8uDduFU87s/AKK95JUT+Up6Vjvp2agdONLt7GqvaX/xtwbM7hQm9lGmK3Qeza+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


=E5=9C=A8 2025/8/14 22:37, Peter Zijlstra =E5=86=99=E9=81=93:
> On Thu, Aug 07, 2025 at 08:14:09PM +0800, Zihuan Zhang wrote:
>
>> Freeze Window Begins
>>
>>      [process A] - epoll_wait()
>>          =E2=94=82
>>          =E2=96=BC
>>      [process B] - event source (already frozen)
>>
> Can we make epoll_wait() TASK_FREEZABLE? AFAICT it doesn't hold any
> resources, it just sits there waiting for stuff.

Based on the code, it=E2=80=99s ep_poll() that puts the task into the D s=
tate,=20
most likely due to I/O or lower-level driver behavior. In fs/eventpoll.c:

Line:2097 __set_current_state=20
<https://elixir.bootlin.com/linux/v6.16/C/ident/__set_current_state>(TASK=
_INTERRUPTIBLE=20
<https://elixir.bootlin.com/linux/v6.16/C/ident/TASK_INTERRUPTIBLE>);

Simply changing the task state may not actually address the root cause.=20
Currently, our approach is to identify tasks that are more likely to=20
cause such issues and freeze them earlier or later in the process to=20
avoid conflicts.



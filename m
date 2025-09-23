Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B9DCAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 13:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52FD8E000A; Tue, 23 Sep 2025 09:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A041E8E0001; Tue, 23 Sep 2025 09:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2658E000A; Tue, 23 Sep 2025 09:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73FC68E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:13:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2176AB9CCC
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:13:52 +0000 (UTC)
X-FDA: 83920557504.09.8A89F1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7EB9B40005
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:13:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oMzSrmpP;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758633230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3D9xtbROxNSb9Gijb8GsRs1BUgX1Qfy/IJ4YGECVdo=;
	b=KgK+Dk9f3OS0re1iqUPNhmb5VnjZdtFlf5V8WeNaN9aDlxLrV+Z27IIg0UmBiVr13siaI8
	woRolOn90o7rXjwyL/n9ETZfRqch2jlzwVM55dvUIgpzgMiGYqfSzeoXY4M/S/heaoiC8P
	1mgLz6TAvO8w++96qQ3yDks5XghMuV0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oMzSrmpP;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758633230; a=rsa-sha256;
	cv=none;
	b=PntLqu1bV0WQUSKwfdxBF2y6a1+u4oRGY5+eDmd05zal3uGTX2amYbPPbttqZNhj7Ynxkh
	wPw7LiKpaxGaQX2vYLTsmLK5BLwiPMy2Y8boF1eX836fDsgKs2+TsBUJ7+8IGKhIW/2Oad
	8lASVrphHaJ7Ahyp4pYH+YepPnWQ1cs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D36D6020D;
	Tue, 23 Sep 2025 13:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE3FC4CEF5;
	Tue, 23 Sep 2025 13:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758633229;
	bh=h3D9xtbROxNSb9Gijb8GsRs1BUgX1Qfy/IJ4YGECVdo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=oMzSrmpPP/PZ4MdZMnfT6nG+/zBR7nn6g4tNnGPoailLJCzHkLsoyL30vp2ur1OAe
	 EycvqkFLaoVGg4yXwf3Wtfknm3B+XyCYkscA//AR42PLBwLn9pgexqrCmAXYWHg/Iw
	 H4g3S8fTTcMXihhCLXObOJ1DaQfxHLWyGCGANTs8ARSYE9CZKaenjyK3DCcPmMORyH
	 iVD2FcM37OTUlRno11vUbxH0btrUd/4HR+12ckF9hFXqUvuZNBJzOLV4wVY0nSSvE4
	 ftvgaY/8Z5DZc9cL58e1XsahlgGD+qnui47PHZggyP/6oaZZDQLpk3oYdNe/iMQRu3
	 LiDgzMSCbyraw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  jasonmiu@google.com,
  graf@amazon.com,  changyuanl@google.com,  rppt@kernel.org,
  dmatlack@google.com,  rientjes@google.com,  corbet@lwn.net,
  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 17/30] liveupdate: luo_files: luo_ioctl: Unregister
 all FDs on device close
In-Reply-To: <CA+CK2bD_-xwwUBnF4TBCBuX33uL6+V_1nN=0Q8_NXwhubTc8yA@mail.gmail.com>
	(Pasha Tatashin's message of "Mon, 22 Sep 2025 17:23:11 -0400")
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-18-pasha.tatashin@soleen.com>
	<mafs07byoye0q.fsf@kernel.org>
	<CA+CK2bD_-xwwUBnF4TBCBuX33uL6+V_1nN=0Q8_NXwhubTc8yA@mail.gmail.com>
Date: Tue, 23 Sep 2025 15:13:38 +0200
Message-ID: <mafs0v7l9l3b1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s96j3wzsh75suw9wsxqtp8syouazhc64
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EB9B40005
X-Rspamd-Server: rspam04
X-HE-Tag: 1758633230-841990
X-HE-Meta: U2FsdGVkX19mM9oZRbCXTwWN5oFaAZqVtFU0SzDmL/MUthM4FoqwxSx/nNZ5DQqBG0cYixhqyQsA3XyCQ2T65918M/XCcDf2eajVWXrkde4SX1movUWePT7s839VYrg3uVgfxWtf3dd0ATILAYaGw2vsJ2C78HCJJo3+6/ixhERRXNl1ishM4o1LEjzMK8RS/mpPzlQmi/zAIO1FptJXv02yQDi6o9GSD4d4ayZNnkDjupuZoASP/5arKiwjjyfmsfojaq5NDrnwxz14JQ9Odx2G35rU+VbASaf8y0LIbkDK2bESM+A9zrVdzhprcuEiE3cIlcH2oGX46B0guCFVQiBPsWkbiZPhPSkuLXKq2mFRLtl1tCUkPGhCY99NrAyGe26aRKMMcKX3tmDeEaBuvGGsQpymImsh7uiaj3dzrNuNJw4B2gjAuJ1/6tUJkv0tzq3V+7hRcrv6cXf9OITj9foGUDqvdfuyeYRorUotLxiv4VtHgAw/5sIHwzHJW6VXUlU89od7584Dmt4fq+ga2W84macKwECndQ39CM7xZWnjddKXAriZdaBcflpApTrMmUA13HSXMBKkgv83y0ZVIxhj3B3JQ/ZttGf5OY9FM3vYrXPl/G9gs7SbEZFWzXxuUL8hgehHhcHdCYzM3G6QmaaRd9fkABKzvb0qq1og546eRp7e4tgHMnYYXHPXqKGoWfiCwIOlMUDP+8OCfRa7RppRAGpTUqIWvHP0t0OO9TX0i2znaNwm3/1kKeeE+7M9ohcmdYgqkP7ufVTWRDvlpfnVQm5yjL8B5Ib4LV1qr2+fiJLzt5J2ao5Ti/daixbLTZql5KZChObUqtWTRj69ZDJUec6zKELAtU2JePhwMMf2ucCvB582gKtdQYrpEHqlew4AaFrd0VwIeBbIyyyUinTRgl92x5MYjmfu9EUcuJfbkEsHO6rOjPxWezr1KARdvF9ac7L1mxbfJFqWAzw
 X0A2jhxz
 ZVH6G3lFNv5c7Los7tW+EjO8CvqKlv0GoDb4l76RiFX/1fFaPZ3jGbowP6knxz90J0yFyZ+fKlFfUA7LXu/PI1Q5fJHMuV5xL4kCDTOOu2L3f/lipwzwm2U17SK5ujJf28IuZ2YeH41uBnnFxYLhx0aUIkYSZ+5exfCJRnHQaGuTXxM2kt/yJxGsFSLX9n9g2jKnN2Fij1Z4Pj6gCYz+fOyeHkWedu1iaqL/juU3Bde+bec9xCir/2/w282gEFZ55YkpUMuFMHgIDWbuL0Ghp0Asklla6uFBen9IMx6oSpyd1B5SAhbpkn/HUGHm6H9lHKT+Gjqr4QYzQWbrVp/ciHqEc9ZdhAHnkFDxePiB/YU7ufPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22 2025, Pasha Tatashin wrote:

> On Wed, Aug 27, 2025 at 11:34=E2=80=AFAM Pratyush Yadav <pratyush@kernel.=
org> wrote:
>>
>> Hi Pasha,
>>
>> On Thu, Aug 07 2025, Pasha Tatashin wrote:
>>
>> > Currently, a file descriptor registered for preservation via the remai=
ns
>> > globally registered with LUO until it is explicitly unregistered. This
>> > creates a potential for resource leaks into the next kernel if the
>> > userspace agent crashes or exits without proper cleanup before a live
>> > update is fully initiated.
>> >
>> > This patch ties the lifetime of FD preservation requests to the lifeti=
me
>> > of the open file descriptor for /dev/liveupdate, creating an implicit
>> > "session".
>> >
>> > When the /dev/liveupdate file descriptor is closed (either explicitly
>> > via close() or implicitly on process exit/crash), the .release
>> > handler, luo_release(), is now called. This handler invokes the new
>> > function luo_unregister_all_files(), which iterates through all FDs
>> > that were preserved through that session and unregisters them.
>>
>> Why special case files here? Shouldn't you undo all the serialization
>> done for all the subsystems?
>
> Good point, subsystems should also be cancelled, and system should be
> brought back to normal state. However, with session support, we will
> be dropping only FDs that belong to a specific session when its FD is
> closed, or all FDs+subsystems when closing /dev/liveupdate.

Yeah, that makes sense.

[...]

--=20
Regards,
Pratyush Yadav


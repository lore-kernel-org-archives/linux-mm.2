Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC0B606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 09:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=n8KPW91Y
Received: by kanga.kvack.org (Postfix)
	id 0C7036B05B0; Sun, 25 Oct 2026 05:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0786C6B05B1; Sun, 25 Oct 2026 05:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED09A6B05B2; Sun, 25 Oct 2026 05:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1BEF6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 05:04:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F24816058A
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 09:04:48 +0000 (UTC)
X-FDA: 85360563456.27.118CC81
Received: from outbound.mr.icloud.com (mr-2005a-snip4-1.eps.apple.com [57.103.71.104])
	by imf15.hostedemail.com (Postfix) with ESMTP id 61530A0002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 09:04:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=n8KPW91Y;
	spf=pass (imf15.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.71.104 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792919086;
	b=PrBRpKiLw2Jj4vvnZRdJl5KC3iZ4IhAg3RrDJc2k6WEQHa8H0B70wKFpP6M3uNo4Dt75F3
	aeopztPKcViy8c29jNdVSNLbbHtD7PVbzcbFYugRh4K/3ZujEope8FtLnYsGNUDSzhD/3Y
	AG28JzW/IcGpS4wqrTS5aDnDBh7kAKU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=n8KPW91Y;
	spf=pass (imf15.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.71.104 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792919086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOi3xKFuD5aMiykE6n/is/ksMvy+vPNzfzFiKL8PDQ8=;
	b=TBPUEutZ1qyIY9spyuyBh7Ki3IQrpAr7TRcdQbLnN7GEnNGg+hiD5nE1aWec9ddlk4eBVL
	Ll4HvE9fDGCHRn2hjUmI1yudwp+YpbVWWsUb9wWwXSppgKON9QvtTvTg2IoK6M4+zPnqbF
	6xKo7Uus2nWKJKbwuRp0cxuG/iS3FVo=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-0 (Postfix) with ESMTPS id 708E118001AA;
	Sun, 25 Oct 2026 09:04:42 +0000 (UTC)
X-ICL-RepId: 01a1724e-158a-7570-8328-3c57c632e5f3
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQtJCkMGXwFeCEADQwZbC1BcHA4XXhtCFUsVXANcDkswUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAZTEhhcFFxQWB5GElYNXQkZBkBeUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKV1MECj9xXX0/Hx9PSB5ecR5yMmstaTd/Knw3FDVwXAlLRglJHQ4EVAddBV0=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1792919085; x=1824455085; bh=tOi3xKFuD5aMiykE6n/is/ksMvy+vPNzfzFiKL8PDQ8=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=n8KPW91YdrPL43/7QW+3LMqcJ10W7LFjD09kvgC+lUG3DVktJ0AbAofUPvfpO/jDPKulgwGac84lpL42JNT/FL+/0XyMuYMvQsavYg3qq5OIyeLT/t0E1taWWaume0k9xU7vOpymZBERMbVJWP4Kmp/V1cE8sMVFaHxxq2hg9D/LTiVRqNRQRo4qbEdHR/ct3E4Lxgt32nRGIms1031Q6jukpRyHX6VjDM/+mRlBwX0RpNI5f5kKfwXFNvvbLtl6drrCjmM3ry1hTHJl7gaYYebua7+D5TuXjvnNo5BboDwYBeN+JFFTSSWYyVX3UqE6A9DwcKdUzPP9pVmpfw0SaA==
Received: from BRUZZHANG-MC1 (unknown [17.156.200.36])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-0 (Postfix) with ESMTPSA id 3EF1518001BA;
	Sun, 25 Oct 2026 09:04:36 +0000 (UTC)
Date: Sun, 25 Oct 2026 17:04:30 +0800
From: Zhang Peng <zippermonkey@icloud.com>
To: baohua@kernel.org
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, bruzzhang@tencent.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, zippermonkey@icloud.com
Subject: Re: [PATCH 0/4] mm/vmscan: refactor shrink_folio_list()
Message-ID: <at3GB0JT-ov0-3Fu@BRUZZHANG-MC1>
References: <20260920-vmscan-refactor-v1-0-ec04d71cb761@tencent.com>
 <CAGsJ_4yBqZVfrpbXsBJDHhitsHZEGWJhZsHG+uKC+QDxZp42HA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4yBqZVfrpbXsBJDHhitsHZEGWJhZsHG+uKC+QDxZp42HA@mail.gmail.com>
X-Proofpoint-GUID: J4ax-FlMMK39gxb3GUctmllKOJrnaAdo
X-Proofpoint-ORIG-GUID: J4ax-FlMMK39gxb3GUctmllKOJrnaAdo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI1MDAzNiBTYWx0ZWRfX7R7+nokb7lNa
 T/q6Tk8GWxG5n43ok+XW/db6pcVC7RxE1QOJmD6k4HRMThuk/1nN0czPPCArBjCpZgCsiRYaPh9
 HyV3HEsR+rW7o10w6qNYJRVGkzDMpJDmSxhhRAUuigi7K7Yx2rs827R/E0ywBcwPZUumhGziNHr
 ewkiH9VwL+j09eCgprJwqV3yDbHD7W6iUnz0+q7TGxSaLZDst2XfvGHb1QYeczxNh5vh7yGKj9T
 GYWeqdMxqUeAchOt7ZHPe9x8ax5wc+HFgoYbQDCYcy2FAVLTF8sWuB3L9bHGidxUbhC+Amw1AQI
 Mmi6lWBOXoeA/T8Zx8Sn4yONbtUHzlRTfaCdkx3K7c0B8c2ahrw4s/kYiCniHc=
X-Authority-Info-Out: v=2.4 cv=XNo9iAhE c=1 sm=1 tr=0 ts=6addc62c
 cx=c_apl:c_pps:t_out a=9mRn2PO/+PIrVdEbaIuMPg==:117
 a=9mRn2PO/+PIrVdEbaIuMPg==:17 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Jl6AdROc3aInEt3dI9QA:9 a=CjuIK1q_8ugA:10
X-JNJ: AAAAAAAB7lLXznPVkUscheJRJVg9F5pRpohOmOK0pxzqWp9w7xD8HljBKTcodAQUThZib/2VfRmKgYb/Ga4NyYaybJeHreEf/skGnG4m/n3EPFunCsNLFz7o5kvydYoOwqcs+Mn4/hKqTwwOtlAhpgzwP6rxCJXVbj7kz13K0V1Wogh+wQcHlhip0gjjzwe7shhj26aev3urv+ijaFNyd+aWdgAYyzT77n57x944QubWIe2OeWOjfiInZh6C7/BZ4nrpvHsnr8Qa7PIRkQiso0poPWzSJ1vjfldqlKFBpNIS8CTYzRaZzqXeaK2+3D2pddUBXIISDb+gxXqDJgNOrbir1l1yZE6sgdvI06hsmc4f+3PCo4CgghfVg2ZW1I6mfseOpDkyC8FZE+Fq5jedl8ljtP2FmR+uE2556CFlxGfiRkHe6dbqepykaKLJ8ll1Gx2OwNbUkI33O/vTQS9Sw8+rULlikoY7YAPMXTMmd8ZX848OPyrfRujHX8VRo5oPU9sa26mAIqaM3a/64DLo8N4g/MBdf7HeOxQ29Ksq0XCtHGHJzlzS6gRAmGjSko42/sfOH05cckktF61MUjyFIfHjLaIxt6u+O6bN0ygJhPib3qIrNQgCfP2iFFi/GLNPk15JtZ/lvZvt8epf/dGY7mFvzeK+4hSQTz67QmSESHg88VVyjw7vV3YLBVjImMFzXlWZz6yxQejbFh6C9z+TrNgEE51adigH4OIQjALgmJoowfRFzAgxWkK0+5hm17VQoxmtfPzf1ZZobE8fy+9IlLIs1wiqDcQsaZx2Im2FvE1tdwqQguYwxufOnKLSdkRKGOC41A8IWgW9AHOb04nTUVTirPy5V4qng7hk+3OrYuPKLuLMLbPRHoOYYaTm1lBIF07NNjAzdQyr22eF8Pa01HxV51U+DWdH72TrN2T+HdddlzROPgCagaLjbq9XuuNt5LfrfEMnnZFPFe73N+rv44T
 m2c/PwWl
 pHCikqwXkaFCc5gZXKclMwJplmIf/IfeSfjJ8D7+x/CX6KADw6xnnMVi58ytNhQRsbXbfzvXoIOd00FJDgeCclYZWz9GlUlp1XnfATlnPAypdOCReMcULnvHHTNqpH7J6Y1XEOP97cbzek/8okyEdJ0ukzBj9QBuGBTDeQXg988Wq7g66sLkaWPpSK51I5Waw0aCpJkv3IKEpXTyj9wy6TOe6LY/ja70oMkO6sbN/feqGIjX5yNRmGl3m3nknR+3KkQa2RHmM3lzfKA73pnu4EgNpHAcU3alNYMTdrBfMwgm6XJAT+bHUFiOqCbMh86bMWdO3LtIeue2uTcS8516Oi6Ma8w/amwrM+ibu7poBaS5u6y0MVoc9hrYou/XCZlg++ts8hHhvn5pOyGq8Eq7RYcceTUqzfStNaxTo0WPc/8MTe9j0GOO5wacnBNsSJJt8SjZuXFiVw7difvLRykaCt0yn+mjZWeiN1yQkeEbPLeKOThwNQk//vtc=
X-Rspam-User: 
X-Rspamd-Queue-Id: 61530A0002
X-Stat-Signature: rr39f7wx4e3dtzybcw7rgf5kqk5r9zhu
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792919086-86455
X-HE-Meta: U2FsdGVkX1/RCDnLpYLvA5tWUu020IKigcfP0IL91/sIB8uE9+9ivsB40JVebswbRjyyRBsx1aesCUecXlt/ARBSLyuvEoZ1RUfZF5s9JW65hJBD/gT35FP4lyR1SyDA3jyqk1SQWDEIpvIr77bcMDYyIZjd5CZil585djrbnyArJProOv6+GLzoIYScqLuW8Ymx8Gee+ynCuQL6mUy3XffCVFvEM6ImVAkgdQBwmB6t9mfaXPzT7Il3Nz6IR/H+xPMi3qelSb/egW67eD+2l8GWbDghbzMlcEauPwLXYCvl4LyxTOJM4geyDForek6B1dwUOArQLtv6DblXetn4YBFRy/VuNmA91u3YvLhj90lwm5465UsMMkuzSYcbHvxGLJlHkB1wwkkYTvZbFZ6LqOYRUJ9aUBJsqgPlYHWRoSGSwosSFO/M5vQNpocUZBzvJ1dBY+sLXkxW/9/613Ynj8VTJJoUmrPYYmXA+hZGS+FEvcvlrEMTfYcVDWZukNkFQqjl7HzqmDHmN3+dZPeEBtc4gPprN/mvbWvp/a5Mq9eyr92gOimtMVHYvyPNjvzow8RwVms1/AWMXcADxGXFsfMDniQQBG9LLnZJZ0AEdo9xPhQk03V6tBfWI1+eiAL+DXV+lVSGuCGleuQRalTT7XqBnl6SF6vOMX+mkxaTfOlBD5QiPyBa5GM0xxFrDkvUvRVDMSCARKIQV+IYyG09XPHv/xWDuTa7CYCqtSSEESY3iBV5aDKubu68k0R4HhI45/DaVy9sU9oJrnqmrpj/7Svzod6wA+hwPiXrz7ZHOI6z7UuqbCE93Of8qIgxNgrpiPWSjJv+ygW8DzuTsAY+AffDkmUtfBCTEfT735Xh9rg73crd2LSC1ktOSYUcWk6Qq7yw4QM3r/wVtvDck4rNWhY7ksN5RFkncfB/xYgB/CtPzi9aa50Js5WWmYnuIM4Rgk1uvwZEgpw3ekUJ4sU
 AGUUFrdP
 YJ6DYi0xZ9YzrfJ1DkLveT0PYt/TCh1cR6OW1z/Zg6JvcT0DupM9TFq1CkmZx1Ov8DXGPYucIeWOgpSfOpNkA4RPdL7GjtNljkTjOBamhDeYD2a1izTW0OZycyqdAtioB/a1gBjy30gM0P9sBxK2V09ZiDSsswRh504mlZq3QC76t3lR7y/qParRX4n4Rq890S5RmgntivydxMXO+uZUn8zPrOOr5w4NELHid2jXbwvu0NvnL9mybgTLWK+mHgniYH8cFygAnEEN+74v3T66JiaYbFU9vb3lPNEud9/i67F+e4ew4kMmEXDBUnAevE0RF1PhHOyU5z42h/4GEY2JIGLMTPhqWN5DqYgrYyMLA8I3ENaxYG7l98WLciWkD9B6di5NXPOAfAAAKXe6n4mYybKYbUjm6RQKzrZ1t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 4:47 PM Barry Song <baohua@kernel.org> wrote:
>
> As suggested, I think it would be better to include patch 5
> ("[PATCH v5 5/5] mm/vmscan: flush TLB for every 31 folios
> evictions")[1] in the same series as patches 1-4, since
> patches 1-4 don't really stand on their own without patch 5.
>
> The whole series is a really good idea.
> Looking forward to the next version.

Hi Barry,

Sorry for the long silence on this - the series has been sitting
longer than I intended, and I should have sent an update before
now rather than letting the thread go quiet.

I agree with folding 5/5 back in: the cleanup only really makes
sense as the groundwork for the batching patch, and keeping them
in one series also makes the ordering self-evident. The next
version will be a single series - patches 1-4 first, then the
TLB batching on top, reworked against the explicit-outcome
helpers.

I'm finishing that up now and expect to post it within the next
few days.

Thanks
Zhang Peng

